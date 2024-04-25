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
                storage.value[keyPath: keyPath as! WritableKeyPath<Root, Value>] = newValue
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
    
    @Observable
    class Storage: StorageProtocol {
        var value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
}

extension Shared where Value: MutableCollection, Value.Index: Hashable {
    subscript(index: Value.Index) -> Shared<Value.Element> {
        Shared<Value.Element>(self.storage, keyPath: self.keyPath.appending(path: \Value.[index])!)
    }
}

extension Shared where Value: MutableCollection, Value.Index: Hashable, Value.Element: Identifiable {
    subscript(element: Value.Element) -> Shared<Value.Element> {
        NSLock().withLock {
            let index = self.wrappedValue.firstIndex(where: { $0.id == element.id })!
            return self[index]
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
