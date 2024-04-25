import Foundation
import ComposableArchitecture

protocol StorageProtocol<Value>: AnyObject {
    associatedtype Value
    var value: Value { get set }
}

@propertyWrapper
@dynamicMemberLookup
struct Shared<Value> {
    var keyPath: AnyKeyPath
    var wrappedValue: Value {
        get {
            func open<Root>(_ storage: some StorageProtocol<Root>) -> Value {
                storage.value[keyPath: keyPath] as! Value
            }
            return open(self.storage)
        }
        set {
            func open<Root>(_ storage: some StorageProtocol<Root>) {
                if let keyPath = keyPath as? WritableKeyPath<Root, Value> {
                    storage.value[keyPath: keyPath] = newValue
                } else if let keyPath = keyPath as? WritableKeyPath<Root, Value?> {
                    storage.value[keyPath: keyPath] = newValue
                } else {
                    fatalError("invalid keyPath")
                }
            }
            open(self.storage)
        }
    }
    
    private let storage: any StorageProtocol
    
    init(wrappedValue: Value) {
        self.keyPath = \Value.self
        self.storage = Storage(wrappedValue)
    }
    
    init(_ storage: some StorageProtocol, keyPath: AnyKeyPath) {
        self.keyPath = keyPath
        self.storage = storage
    }
    
    var projectedValue: Shared<Value> {
        self
    }
    
    subscript<Member>(dynamicMember keyPath: WritableKeyPath<Storage.Value, Member>) -> Shared<Member> {
        Shared<Member>(self.storage, keyPath: self.keyPath.appending(path: keyPath)!)
    }
    
    subscript<Member>(dynamicMember keyPath: WritableKeyPath<Storage.Value, Member?>) -> Shared<Member>? {
        func open<Root>(_ storage: some StorageProtocol<Root>) -> Member? {
            storage.value[keyPath: keyPath as AnyKeyPath] as? Member
        }
        if open(self.storage) != nil {
            return Shared<Member>(self.storage, keyPath: self.keyPath.appending(path: keyPath)!)
        }
        return nil
    }
    
    @Observable
    class Storage: StorageProtocol {
        var value: Value
        
        init(_ value: Value) {
            self.value = value
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

extension Shared: Decodable where Value: Decodable {
    init(from decoder: any Decoder) throws {
        self = try Shared(wrappedValue: Value(from: decoder))
    }
}

extension Shared: Encodable where Value: Encodable {
    func encode(to encoder: any Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}
