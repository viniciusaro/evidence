import Combine
import CasePaths

typealias StoreOf<F: Feature> = Store<F.State, F.Action>

class Store<State, Action> {
    @Published fileprivate var state: State
    private let reducer: Reducer<State, Action>
    private var effectCancellables: [any EffectCancellable] = []
    
    init(initialState: State, reducer: Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        let effect = reducer.run(&state, action)
        effectCancellables.append(effect.run(send))
    }
    
    func scope<LocalState, LocalAction>(
        state keyPath: WritableKeyPath<State, LocalState>,
        action toAction: CaseKeyPath<Action, LocalAction>
    ) -> Store<LocalState, LocalAction> {
        Store<LocalState, LocalAction>(
            initialState: state[keyPath: keyPath],
            reducer: Reducer { localState, localAction in
                let action = toAction(localAction)
                self.send(action)
                localState = self.state[keyPath: keyPath]
                return .none
            }
        )
    }
    
    func scope<LocalState, LocalAction>(
        state toLocalState: @escaping (State) -> LocalState,
        action toAction: CaseKeyPath<Action, LocalAction>
    ) -> Store<LocalState, LocalAction> {
        Store<LocalState, LocalAction>(
            initialState: toLocalState(state),
            reducer: Reducer { localState, localAction in
                let action = toAction(localAction)
                self.send(action)
                localState = toLocalState(self.state)
                return .none
            }
        )
    }
    
    func scope<LocalState: Identifiable, LocalAction>(
        state toLocalState: @escaping (State) -> LocalState,
        action toAction: CaseKeyPath<Action, (LocalAction, LocalState.ID)>
    ) -> Store<LocalState, LocalAction> {
        Store<LocalState, LocalAction>(
            initialState: toLocalState(state),
            reducer: Reducer { localState, localAction in
                let action = AnyCasePath(toAction).embed((localAction, localState.id))
                self.send(action)
                localState = toLocalState(self.state)
                return .none
            }
        )
    }
    
    deinit {
        effectCancellables.forEach { $0.cancel() }
    }
}

@dynamicMemberLookup
class ViewStore<State, Action>: ObservableObject {
    @Published var state: State
    private var storeSinkCancellable: AnyCancellable?
    private(set) var send: (Action) -> Void
    
    init(store: Store<State, Action>) {
        self.state = store.state
        self.send = store.send
        self.storeSinkCancellable = store.$state.sink { [weak self] update in
            self?.state = update
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        return state[keyPath: keyPath]
    }
    
    deinit {
        self.storeSinkCancellable?.cancel()
    }
}
