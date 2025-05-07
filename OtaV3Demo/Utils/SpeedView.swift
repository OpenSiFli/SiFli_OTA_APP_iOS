import Foundation

class SpeedPoint {
    var timestamp: TimeInterval
    var completeBytes: Int64
    
    init(timestamp: TimeInterval = Date().timeIntervalSince1970, completeBytes: Int64 = 0) {
        self.timestamp = timestamp
        self.completeBytes = completeBytes
    }
}

class SpeedView {
    private var firstPoint: SpeedPoint?
    private var before3SecPoint: SpeedPoint?
    
    private(set) var currentSpeed: Double = 0.0
    private(set) var averageSpeed: Double = 0.0
    
    func viewSpeedByCompleteBytes(_ completeBytes: Int64) {
        let timeNow = self.timeNow()
        if firstPoint == nil || firstPoint!.completeBytes <= 0 {
            self.firstPoint = SpeedPoint(timestamp: timeNow, completeBytes: completeBytes)
        } else {
            let time = timeNow - firstPoint!.timestamp
            let size = completeBytes - firstPoint!.completeBytes
            self.averageSpeed = getKbPerSec(size: size, time: time)
        }
        
        if before3SecPoint == nil {
            self.before3SecPoint = SpeedPoint(timestamp: timeNow, completeBytes: completeBytes)
        } else {
            let time = timeNow - before3SecPoint!.timestamp
            let size = completeBytes - before3SecPoint!.completeBytes
            self.currentSpeed = getKbPerSec(size: size, time: time)
        }
        
        if timeNow - self.before3SecPoint!.timestamp > 3 {
            self.before3SecPoint = SpeedPoint(timestamp: timeNow, completeBytes: completeBytes)
        } else {
            let time = timeNow - before3SecPoint!.timestamp
            let size = completeBytes - before3SecPoint!.completeBytes
            self.currentSpeed = getKbPerSec(size: size, time: time)
        }
    }
    
    func clear() {
        self.currentSpeed = 0
        self.averageSpeed = 0
        self.firstPoint = nil
        self.before3SecPoint = nil
    }
    
    func getSpeedText() -> String {
        return String(format: "瞬时 %.1f KB/s 平均 %.1f KB/s", self.currentSpeed, self.averageSpeed)
    }
    
    func getSpeedText(currentBytes: Int64, totalBytes: Int64) -> String {
        let currentM = Double(currentBytes) / (1024 * 1024)
        let totalM = Double(totalBytes) / (1024 * 1024)
        return String(format: "瞬时 %.1f KB/s 平均 %.1f KB/s %.1f/%.1fMb", self.currentSpeed, self.averageSpeed, currentM, totalM)
    }
    
    private func getKbPerSec(size: Int64, time: TimeInterval) -> Double {
        let kb = Double(size) / 1024
        let sec = time
        return sec == 0 ? 0 : kb / sec
    }
    
    private func timeNow() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
}
