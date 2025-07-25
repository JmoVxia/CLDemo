//
//  CLRecorder.swift
//  CKD
//
//  Created by Chen JmoVxia on 2024/5/28.
//  Copyright © 2024 JmoVxia. All rights reserved.
//

import AudioToolbox
import AVFoundation
import Foundation

class CLRecorder: NSObject {
    override init() {
        super.init()
        initFolder()
        initRemoteIO()
        mp3Encoder.run()
    }

    deinit {
        mp3Encoder.stop()
        guard let audioUnit else { return }
        AudioUnitUninitialize(audioUnit)
    }

    private lazy var mp3Encoder: CLMp3Encoder = {
        let encoder = CLMp3Encoder()
        encoder.inputSampleRate = 44100
        encoder.outputSampleRate = 44100
        encoder.outputChannelsPerFrame = 1
        encoder.bitRate = 16
        encoder.quality = 9
        encoder.processingEncodedData = { [weak self] mp3Data in
            guard let self else { return }
            writeData(mp3Data)
        }
        return encoder
    }()

    private var mp3Path: String = ""

    private let lock = NSLock()

    private var audioUnit: AudioUnit?

    private var fileHandle: FileHandle?

    private var otherAudioPlaying = false

    private var lastSecond = Int.zero

    var durationCallback: ((Int) -> Void)?

    var finishCallback: ((CGFloat, Data) -> Void)?

    var audioDuration: CGFloat {
        guard !mp3Path.isEmpty else { return .zero }
        return CMTimeGetSeconds(AVURLAsset(url: URL(fileURLWithPath: mp3Path)).duration)
    }
}

private extension CLRecorder {
    private func initFolder() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: CLPath.Folder.tmp) {
            try? fileManager.createDirectory(atPath: CLPath.Folder.tmp, withIntermediateDirectories: true, attributes: nil)
        }
    }

    private func initRemoteIO() {
        initAudioComponent()
        initFormat()
        initAudioProperty()
        initRecordCallback()
        initAudioUnit()
        initBuffer()
    }

    private func initAudioComponent() {
        var audioDesc = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                                  componentSubType: kAudioUnitSubType_RemoteIO,
                                                  componentManufacturer: kAudioUnitManufacturer_Apple,
                                                  componentFlags: 0,
                                                  componentFlagsMask: 0)

        let inputComponent = AudioComponentFindNext(nil, &audioDesc)
        AudioComponentInstanceNew(inputComponent!, &audioUnit)
    }

    private func initFormat() {
        guard let audioUnit else { return }
        var audioFormat = AudioStreamBasicDescription(mSampleRate: 44100,
                                                      mFormatID: kAudioFormatLinearPCM,
                                                      mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked,
                                                      mBytesPerPacket: 2,
                                                      mFramesPerPacket: 1,
                                                      mBytesPerFrame: 2,
                                                      mChannelsPerFrame: 1,
                                                      mBitsPerChannel: 16,
                                                      mReserved: 0)

        AudioUnitSetProperty(audioUnit,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Output,
                             1,
                             &audioFormat,
                             UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
    }

    private func initAudioProperty() {
        guard let audioUnit else { return }
        var flag: UInt32 = 1
        AudioUnitSetProperty(audioUnit,
                             kAudioOutputUnitProperty_EnableIO,
                             kAudioUnitScope_Input,
                             1,
                             &flag,
                             UInt32(MemoryLayout<UInt32>.size))
    }

    private func initRecordCallback() {
        guard let audioUnit else { return }

        var recordCallback = AURenderCallbackStruct(inputProc: { inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData -> OSStatus in
            let recorder = Unmanaged<CLRecorder>.fromOpaque(inRefCon).takeUnretainedValue()
            return recorder.recordCallback(ioActionFlags: ioActionFlags, inTimeStamp: inTimeStamp, inBusNumber: inBusNumber, inNumberFrames: inNumberFrames)
        }, inputProcRefCon: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))

        AudioUnitSetProperty(audioUnit,
                             kAudioOutputUnitProperty_SetInputCallback,
                             kAudioUnitScope_Global,
                             1,
                             &recordCallback,
                             UInt32(MemoryLayout<AURenderCallbackStruct>.size))
    }

    private func initAudioUnit() {
        guard let audioUnit else { return }
        AudioUnitInitialize(audioUnit)
    }

    private func initBuffer() {
        guard let audioUnit else { return }
        var flag: UInt32 = 0
        AudioUnitSetProperty(audioUnit,
                             kAudioUnitProperty_ShouldAllocateBuffer,
                             kAudioUnitScope_Output,
                             1,
                             &flag,
                             UInt32(MemoryLayout<UInt32>.size))
    }

    private func recordCallback(ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                                inTimeStamp: UnsafePointer<AudioTimeStamp>,
                                inBusNumber: UInt32,
                                inNumberFrames: UInt32) -> OSStatus
    {
        var bufferList = AudioBufferList(mNumberBuffers: 1,
                                         mBuffers: AudioBuffer(mNumberChannels: 1,
                                                               mDataByteSize: 0,
                                                               mData: nil))
        AudioUnitRender(audioUnit!, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList)
        mp3Encoder.processAudioBufferList(bufferList)
        let second = Int(floor(audioDuration))
        if lastSecond != second {
            lastSecond = second
            DispatchQueue.main.async {
                self.durationCallback?(second)
            }
        }
        return noErr
    }

    private func removeFile() {
        DispatchQueue.global().async {
            try? FileManager.default.removeItem(atPath: self.mp3Path)
            self.mp3Path = ""
        }
    }

    private func activateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        otherAudioPlaying = audioSession.isOtherAudioPlaying
        try? audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
        try? audioSession.setPreferredSampleRate(44100)
        try? audioSession.setPreferredInputNumberOfChannels(1)
        try? audioSession.setPreferredIOBufferDuration(0.023)
        try? audioSession.setActive(true)
    }

    private func resumeAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        if otherAudioPlaying {
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } else {
            try? audioSession.setCategory(.playback)
            try? audioSession.setActive(true)
        }
    }

    private func writeData(_ data: Data) {
        lock.lock()
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(data)
        lock.unlock()
    }
}

extension CLRecorder {
    func start() {
        guard let audioUnit else { return }
        lastSecond = 0
        DispatchQueue.main.async {
            self.durationCallback?(0)
        }

        mp3Path = CLPath.Folder.chatFile.appending("/\(Int(Date().timeIntervalSince1970 * 1_000_000)).mp3")
        if !FileManager.default.fileExists(atPath: mp3Path) {
            FileManager.default.createFile(atPath: mp3Path, contents: nil, attributes: nil)
        }

        fileHandle = try? FileHandle(forWritingTo: URL(fileURLWithPath: mp3Path))
        if fileHandle != nil {
            activateAudioSession()
            let status = AudioOutputUnitStart(audioUnit)
            if status != noErr {
                CLLog("startRecorder error \(status)")
            }
        } else {
            CLLog("error: unable to create file handle")
        }
    }

    func cancel() {
        guard let audioUnit else { return }

        let status = AudioOutputUnitStop(audioUnit)
        if status != noErr {
            CLLog("stopRecorder error: \(status)")
        }
        resumeAudioSession()
        removeFile()
    }

    func stop() {
        guard let audioUnit else { return }

        let status = AudioOutputUnitStop(audioUnit)
        resumeAudioSession()
        if status != noErr {
            CLLog("stopRecorder error: \(status)")
        } else {
            guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: mp3Path)) else { return }
            DispatchQueue.main.async {
                self.finishCallback?(self.audioDuration, fileData)
                self.removeFile()
            }
        }
    }
}
