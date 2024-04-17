import Foundation

struct Shared<Value> {
    var wrappedValue: Value {
        get { self.storage.wrappedValue }
        set { self.storage.wrappedValue = newValue }
    }
    
    private let storage: Storage
    
    init(wrappedValue: Value) {
        self.storage = Storage(wrappedValue)
    }
    
    class Storage {
        var wrappedValue: Value
        
        init(_ wrappedValue: Value) {
            self.wrappedValue = wrappedValue
        }
    }
}

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
