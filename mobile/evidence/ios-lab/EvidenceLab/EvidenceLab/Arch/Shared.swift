import Foundation

@propertyWrapper
class Shared<Value> {
    private(set) var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
