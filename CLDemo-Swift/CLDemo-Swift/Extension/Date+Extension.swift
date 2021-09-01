
import UIKit
import DateToolsSwift

extension Date {
    ///秒级时间戳
    var timeStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int64(timeInterval)
        return timeStamp
    }
    ///毫秒级时间戳
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Int64(millisecond)
    }
    ///纳秒级时间戳
    var nanosecondStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let nanosecond = CLongLong(round(timeInterval*1000000000))
        return Int64(nanosecond)
    }
    ///秒级时间戳
    var timeStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String(timeStamp)
    }
    ///毫秒级时间戳
    var milliStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return String(Int(millisecond))
    }
    ///纳秒级时间戳
    var nanosecondStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let nanosecond = CLongLong(round(timeInterval*1000000000))
        return String(nanosecond)
    }

    static func uptimeSinceLastBoot() -> TimeInterval {
        var now: timeval = timeval()
        var tz: timezone = timezone()
        gettimeofday(&now, &tz)
        var boottime: timeval = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout.size(ofValue: boottime)
        var uptime: Double = -1
        if sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0 {
            uptime = Double(now.tv_sec - boottime.tv_sec)
            uptime += Double(now.tv_usec - boottime.tv_usec) / 1000000.0
        }
        return TimeInterval(uptime)
    }
}
