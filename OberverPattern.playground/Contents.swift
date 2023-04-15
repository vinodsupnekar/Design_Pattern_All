import Foundation

enum TrafficeLight: String {
    case Greeen
    case Red
    case Yellow
}

protocol TrafficeLightObserver {
    var Id: Int {get set}
    func onTrafficeLightChange(_ color: String)
}

class VehicleObserver: TrafficeLightObserver {
    var Id: Int
    
    init(_ id: Int) {
        self.Id = id
    }
    
    func onTrafficeLightChange(_ color: String) {
        if color == TrafficeLight.Greeen.rawValue {
            debugPrint("move ahead")
        }
        
        if color == TrafficeLight.Red.rawValue {
            debugPrint("stop ")
        }
        
        if color == TrafficeLight.Yellow.rawValue {
            debugPrint("slow down ")
        }
    }
}

class VendorObserver: TrafficeLightObserver {
    var Id: Int
    
    init(_ id: Int) {
        self.Id = id
    }
    
    func onTrafficeLightChange(_ color: String) {
        if color == TrafficeLight.Greeen.rawValue {
            debugPrint("stop")

        }
        
        if color == TrafficeLight.Red.rawValue {
            debugPrint("move ahead")
        }
    }
}


class TrafficLightSubject {
    private var _color = String()
    
    var trafficLightColor: String {
        get {
            return _color
        }
        set {
            _color = newValue
            // notify observer
            notifyObserver()
            
        }
    }
    
    private var trafficObserver = [TrafficeLightObserver]()
    
    func addObserver(_ observer: TrafficeLightObserver) {
        
    guard trafficObserver.contains(where: { $0.Id == observer.Id }) == false else {
            return }
        
        trafficObserver.append(observer)
    }
    
    func removeObserver(_ observer: TrafficeLightObserver) {
        trafficObserver = trafficObserver.filter { $0.Id != observer.Id }
    }
    
    func notifyObserver() {
        trafficObserver.forEach {
            $0.onTrafficeLightChange(_color)
        }
    }
    
    deinit {
        trafficObserver.removeAll()
    }
}

let trafficeLightSubject = TrafficLightSubject()
let vehicleObserver = VehicleObserver(1)
let vendorObserver = VendorObserver(2)

trafficeLightSubject.addObserver(vehicleObserver)
trafficeLightSubject.addObserver(vendorObserver)

trafficeLightSubject.trafficLightColor = TrafficeLight.Greeen.rawValue

trafficeLightSubject.removeObserver(vendorObserver)


trafficeLightSubject.trafficLightColor = TrafficeLight.Greeen.rawValue


// KVO - KVC

class Bank: NSObject {
    var name: String
    @objc dynamic var phone: String
    
    init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }
}

let bank = Bank(name: "YES", phone: "12345")
bank.phone = "5432"
//KVC
let phone = bank.value(forKey: "phone")

//KVO
//bank.addObserver(bank, forKeyPath: "phone", options: [.new, .old], context: nil)

bank.observe(\.phone, options: [.new, .old]) { (bank, value) in
    print("value oldValue ==> \(String(describing: value.oldValue))")
    print("value newValue ==> \(String(describing: value.newValue))")

}

bank.phone = "0000"
bank.setValue("9999", forKey: "phone")

