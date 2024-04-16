import Foundation

@propertyWrapper
struct Shared<Value> {
    var wrappedValue: Value {
        get { self.storage.wrappedValue }
        set { self.storage.wrappedValue = newValue }
    }
    
    private let storage: Storage
    
    init(wrappedValue: Value) {
        if let shared = sharedValues[String(describing: type(of: wrappedValue))] as? Storage {
            self.storage = shared
        } else {
            self.storage = Storage(wrappedValue)
            sharedValues[String(describing: type(of: wrappedValue))] = self.storage
        }
    }
    
    init(force: Value) {
        if let shared = sharedValues[String(describing: type(of: force))] as? Storage {
            self.storage = shared
            self.storage.wrappedValue = force
        } else {
            self.storage = Storage(force)
            sharedValues[String(describing: type(of: wrappedValue))] = self.storage
        }
    }
    
    class Storage {
        var wrappedValue: Value
        
        init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

private var sharedValues: [String: AnyObject] = [:]

extension Shared: Equatable where Value: Equatable {
    static func == (lhs: Shared<Value>, rhs: Shared<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Shared: Hashable where Value: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
