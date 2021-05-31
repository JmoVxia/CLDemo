//
//  CLSampleDataFilter.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2021/6/2.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

class CLSampleDataFilter {
    var data:Data!
    init(sampleData: Data) {
        data = sampleData
    }
    //按照指定的尺寸约束来筛选数据
    func filteredSamplesForSize(_ size: CGSize, scale: CGFloat = 1) -> [Float] {
        /* 最终需要展示的样本集 */
        var filteredSamples = [Float]()
        //1. 每个样本为16字节,得到样本数量
        let samplesCount = data.count / MemoryLayout<Int16>.size
        //2. 某个宽度范围内显示多少个样本数量
        let binSize = Int(samplesCount / Int(size.width))
        //3. 得到所有字节数据
        /* 注意创建数组作为buffer时,要先分配好内存,即需要指定数组长度 */
        var bytes = [Int16](repeating: 0,count: data.count)
        let data: NSData = data as NSData
        
        data.getBytes(&bytes, length: data.count);
        
        //4. 以binSize为步长遍历所有样本,
        var maxSample: Int16 = 0
        for i in stride(from: 0, to: samplesCount - 1, by: binSize) {
            var sampleBin = [Int16](repeating: 0, count: binSize)
            for j in 0..<binSize {
                /*小端存储,低字节序*/
                sampleBin[j] = bytes[i + j].littleEndian
            }
            //5. 获取每个尺寸单位样本集binSize中的最大样本
            let value = maxValue(in: sampleBin, ofSize: binSize)
            //6. 添加到需要最终需要绘制展示的样本中
            filteredSamples.append(Float(value))
            if value > maxSample {
                maxSample = value
            }
        }
        //7 .根据所有样本中的最大样本值进行缩放
        let scaleFactor = (size.height / scale) / CGFloat(maxSample)
        //8. 对需要展示的样本进行缩放
        for i in 0..<filteredSamples.count {
            filteredSamples[i] = filteredSamples[i] * Float(scaleFactor)
        }
        return filteredSamples
    }
}
extension CLSampleDataFilter {
    private func maxValue(in values: [Int16], ofSize size: Int) -> Int16 {
        var maxValue: Int16 = 0
        for i in 0..<size {
            if abs(values[i]) > maxValue {
                maxValue = abs(values[i])
            }
        }
        return maxValue
    }
}
