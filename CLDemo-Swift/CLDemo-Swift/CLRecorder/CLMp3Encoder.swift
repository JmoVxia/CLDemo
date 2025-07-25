//
//  CLMp3Encoder.swift
//  CKD
//
//  Created by Chen JmoVxia on 2024/5/28.
//  Copyright © 2024 JmoVxia. All rights reserved.
//

import AVFAudio
import Foundation

class CLMp3Encoder {
    deinit {
        stop()
    }

    private static let mp3BufferSize = 4096

    private let encodeQueue = DispatchQueue(label: "CKDMp3Encoder.encodeQueue")

    private var lame: OpaquePointer?
    private var mp3Buffer = [UInt8](repeating: 0, count: CLMp3Encoder.mp3BufferSize)
    private var pcmData1: UnsafeMutablePointer<Int16>?
    private var pcmData2: UnsafeMutablePointer<Int16>?
    private(set) var isRunning = false

    var inputSampleRate = AVAudioSession.sharedInstance().sampleRate
    var outputSampleRate = AVAudioSession.sharedInstance().sampleRate
    var outputChannelsPerFrame = 1
    var bitRate: Int32 = 16
    var quality: Int32 = 5
    var processingEncodedData: ((Data) -> Void)?
}

extension CLMp3Encoder {
    func run() {
        guard lame == nil else { return }

        lame = lame_init()
        guard let lame else { return }

        lame_set_in_samplerate(lame, Int32(inputSampleRate))
        lame_set_quality(lame, quality)
        lame_set_VBR(lame, vbr_default)
        lame_set_brate(lame, bitRate)
        lame_set_out_samplerate(lame, Int32(outputSampleRate))
        lame_set_num_channels(lame, Int32(outputChannelsPerFrame))
        lame_init_params(lame)

        isRunning = true
    }

    func stop() {
        guard let lame else { return }
        lame_close(lame)
        self.lame = nil
        isRunning = false
    }

    func processAudioBufferList(_ audioBufferList: AudioBufferList) {
        guard isRunning else { return }
        encodeQueue.async { [weak self] in
            guard let self else { return }
            guard let audioData = audioBufferList.mBuffers.mData?.assumingMemoryBound(to: Int16.self) else { return }

            let channels = Int(audioBufferList.mBuffers.mNumberChannels)
            let dataSize = Int(audioBufferList.mBuffers.mDataByteSize) / (MemoryLayout<Int16>.size * channels)
            var bytesWritten: Int32 = 0

            if channels == 2 {
                bytesWritten = lame_encode_buffer_interleaved(lame, audioData, Int32(dataSize), &mp3Buffer, Int32(CLMp3Encoder.mp3BufferSize))
            } else if channels == 1 {
                if pcmData1 == nil { pcmData1 = audioData }
                if pcmData2 == nil { pcmData2 = audioData }

                if let pcmData1, let pcmData2 {
                    bytesWritten = lame_encode_buffer(lame, pcmData1, pcmData2, Int32(dataSize), &mp3Buffer, Int32(CLMp3Encoder.mp3BufferSize))
                    self.pcmData1 = nil
                    self.pcmData2 = nil
                }
            }
            guard bytesWritten > 0 else { return }
            processingEncodedData?(Data(bytes: mp3Buffer, count: Int(bytesWritten)))
        }
    }
}
