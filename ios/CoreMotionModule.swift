import Foundation
import CoreMotion
import BackgroundTasks
import React

enum DeviceState: String {
    case up = "PickUp"
    case down = "PutDown"
    case unknown = "Unknown"
}

@objc(CoreMotionModule)
class CoreMotionModule: NSObject {
    let defaultsKey = "core_motion_last_sync_date"
    let recorder = CMSensorRecorder()
    
    @objc(recordMotions)
    func recordMotions(){
        recorder.recordAccelerometer(forDuration: .infinity)
    }
    
    @objc(loadRecordedData:rejecter:)
    func loadRecordedData(_ resolve:@escaping  RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        let now = Date()
        var from:Date = (UserDefaults.standard.value(forKey: defaultsKey) as? Date) ?? now.addDays(days: -2)
        if now.days(sinceDate: from)! > 2 {
            from = now.addDays(days: -2)
        }
        if let list = recorder.accelerometerData(from: from, to:now) {
            let items:[DeviceMotionData] = list.filter({ data in
                data is CMRecordedAccelerometerData
            }).map({data in
                data as! CMRecordedAccelerometerData
            }).map { data in
                let acc = data.acceleration
                let linear = self.linearAcc(acceleration: acc)
                var state : DeviceState
                if acc.z > 0.1 {
                    state = .up
                } else {
                    state = .down
                }
                return DeviceMotionData(
                    date: data.startDate,
                    state: state,
                    x: acc.z,
                    y: acc.y,
                    z: acc.z,
                    acc: linear
                );
            }
            
            let sorted =  items.sorted { a, b in
                return a.date.compare(b.date) == .orderedAscending
            }
            var filtered:[DeviceMotionData] = []
            var ts = sorted.first?.date.timeIntervalSince1970 ?? 0
            for s in sorted {
                if  s.acc > 0.2 && s.date.timeIntervalSince1970 > ts {
                    filtered.append(s)
                    ts += 0.5 // Adding 500ms == 0.5s
                }
            }
            resolve(filtered.map({ $0.toDictionary() }))
            UserDefaults.standard.set(now, forKey: defaultsKey)
            UserDefaults.standard.synchronize()
        }else {
            reject("CoreMotion", "No recorded data", nil)
        }
    }
    
    
    func linearAcc(acceleration: CMAcceleration) -> Double{
        return sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2));
    }
}



extension CMSensorDataList: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}

extension Date {
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func addDays(days:Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = days
        let theCalendar     = Calendar.current
        let from:Date       = theCalendar.date(byAdding: dayComponent, to: self)!
        return from
    }
}


class DeviceMotionData {
    let date: Date
    let state: DeviceState
    let x: Double
    let y: Double
    let z: Double
    let acc: Double
    
    init(date: Date, state:DeviceState, x:Double, y:Double, z:Double, acc: Double){
        self.date = date
        self.state = state
        self.x = x
        self.y = y
        self.z = z
        self.acc = acc
    }
    func toDictionary() -> [String:Any] {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return [
            "date" : formatter.string(from: date),
            "state" : state.rawValue,
            "x" : x,
            "y" : y,
            "z" : z,
            "acc" : acc
        ]
    }
}
