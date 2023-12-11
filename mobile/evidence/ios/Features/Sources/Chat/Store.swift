import Combine
import CasePaths

public enum Effect<Action> {
    case none
    case publisher(any Publisher<Action, Never>)
    case run((@escaping (Action) -> Void) -> Void)
}

extension Effect {
    func map<A>(_ transform: @escaping (Action) -> A) -> Effect<A> {
        switch self {
        case .none:
            return .none
        case let .publisher(publisher):
            return .publisher(publisher.eraseToAnyPublisher().map(transform))
        case let .run(computation):
            let subject = PassthroughSubject<Action, Never>()
            computation(subject.send)
            return .publisher(subject.map(transform))
        }
    }
}

extension Effect {
    static func sync(_ action: Action) -> Effect<Action> {
        .publisher(Just(action))
    }
    
    static func merge(_ effects: [Effect]) -> Effect {
        let publishers: [AnyPublisher<Action, Never>] = effects.map { effect in
            switch effect {
            case .none:
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            case let .publisher(publisher):
                return publisher
                    .eraseToAnyPublisher()
            case let .run(computation):
                let subject = PassthroughSubject<Action, Never>()
                computation(subject.send)
                return subject.eraseToAnyPublisher()
            }
        }
        return .publisher(Publishers.MergeMany(publishers))
    }
}

public typealias Reducer<State, Action> = (inout State, Action) -> Effect<Action>

public func combine<State, Action>(
    _ reducers: Reducer<State, Action>...
) -> Reducer<State, Action> {
    { state, action in
        .merge(reducers.map { $0(&state, action) })
    }
}

public func pullback<LocalState, LocalAction, GlobalState, GlobalAction>(
    _ reducer: @escaping Reducer<LocalState, LocalAction>,
    state toLocalState: @escaping (GlobalState) -> LocalState,
    stateToGlobal toGlobalState: @escaping (inout GlobalState, LocalState) -> Void,
    action toLocalAction: @escaping (GlobalAction) -> LocalAction?,
    actionToGlobal toGlobalAction: @escaping (LocalAction) -> GlobalAction
) -> Reducer<GlobalState, GlobalAction> {
    return { globalState, globalAction in
        var localState = toLocalState(globalState)
        guard let localAction = toLocalAction(globalAction) else {
            return .none
        }
        let localEffect = reducer(&localState, localAction)
        toGlobalState(&globalState, localState)
        return localEffect.map(toGlobalAction)
    }
}

public func forEach<LocalState, LocalAction, GlobalState, GlobalAction>(
    _ reducer: @escaping Reducer<LocalState, LocalAction>,
    state toLocalState: WritableKeyPath<GlobalState, [LocalState]>,
    action toLocalAction: AnyCasePath<GlobalAction, (LocalAction, Int)>
) -> Reducer<GlobalState, GlobalAction> {
    return { globalState, globalAction in
        let localStates = globalState[keyPath: toLocalState]
        guard let (localAction, index) = toLocalAction.extract(from: globalAction) else {
            return .none
        }
        var localState = localStates[index]
        let localEffect = reducer(&localState, localAction)
        globalState[keyPath: toLocalState][index] = localState
        return localEffect.map { localAction in
            toLocalAction.embed((localAction, index))
        }
    }
}

public class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Action>
    private var cancellables = Set<AnyCancellable>()
    
    public init(state: State, reducer: @escaping Reducer<State, Action>) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        let effect = self.reducer(&self.state, action)
        
        switch effect {
        case .none:
            break
        case let .run(computation):
            computation(self.send)
        case let .publisher(publisher):
            publisher.sink { [weak self] action in
                self?.send(action)
            }
            .store(in: &self.cancellables)
        }
    }
    
    func scope<LocalState, LocalAction>(
        state toLocalState: @escaping (State) -> LocalState,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction> {
        return Store<LocalState, LocalAction>(
            state: toLocalState(self.state)
        ) { localState, localAction in
            let action = toGlobalAction(localAction)
            self.send(action)
            localState = toLocalState(self.state)
            return .none
        }
    }
}
