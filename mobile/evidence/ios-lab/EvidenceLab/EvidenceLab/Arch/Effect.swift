//import Combine
//import Foundation
//
//struct Effect<Action> {
//    let run: (@escaping (Action) -> Void) -> any EffectCancellable
//}
//
//extension Effect {
//    func map<OtherAction>(_ transform: @escaping (Action) -> OtherAction) -> Effect<OtherAction> {
//        return Effect<OtherAction> { send in
//            return self.run { action in
//                send(transform(action))
//            }
//        }
//    }
//}
//
//protocol EffectCancellable: Identifiable {
//    func cancel()
//}
//
//struct SomeEffectCancellable: EffectCancellable {
//    private let _cancel: () -> Void
//    let id = UUID()
//    
//    init(_ cancel: @escaping () -> Void) {
//        self._cancel = cancel
//    }
//    
//    func cancel() {
//        _cancel()
//    }
//}
//
//extension UUID: EffectCancellable, Identifiable {
//    public var id: UUID { return self }
//    func cancel() {}
//}
//
//extension AnyCancellable: EffectCancellable {}
//
//extension Effect {
//    static var none: Effect {
//        Effect { _ in UUID() }
//    }
//    
//    static func sync(_ action: Action) -> Effect {
//        publisher(Just(action))
//    }
//    
//    static func run(_ computation: @escaping ((Action) -> Void) throws -> Void) -> Effect {
//        Effect { send in
//            try? computation(send)
//            return UUID()
//        }
//    }
//    
//    static func fireAndForget(_ computation: @escaping () throws -> Void) -> Effect {
//        Effect { _ in
//            try? computation()
//            return UUID()
//        }
//    }
//    
//    static func publisher(_ publisher: any Publisher<Action, Never>) -> Effect {
//        Effect { send in
//            publisher.sink(receiveValue: send)
//        }
//    }
//    
//    static func merge(_ effects: [Effect]) -> Effect {
//        Effect { send in
//            var cancellables = [any EffectCancellable]()
//            for effect in effects {
//                cancellables.append(effect.run(send))
//            }
//            return SomeEffectCancellable {
//                cancellables.forEach { $0.cancel() }
//            }
//        }
//    }
//    
//    static func merge(_ effects: Effect...) -> Effect {
//        return merge(effects)
//    }
//}
