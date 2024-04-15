import Foundation

@propertyWrapper
public class Shared<Value> {
    public private(set) var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Shared: Equatable where Value: Equatable {
    public static func == (lhs: Shared<Value>, rhs: Shared<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
