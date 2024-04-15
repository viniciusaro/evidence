import Foundation

@propertyWrapper
class Shared<Value> {
    private(set) var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Shared: Equatable where Value: Equatable {
    static func == (lhs: Shared<Value>, rhs: Shared<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
