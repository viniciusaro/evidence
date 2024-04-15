import CasePaths
import IdentifiedCollections

typealias ReducerOf<F: Feature> = Reducer<F.State, F.Action>

struct Reducer<State, Action> {
    let run: (_ state: inout State, _ action: Action) -> Effect<Action>
}

extension Reducer where State: Equatable {
    func debug(actionOnly: Bool = false, before: Bool = true, after: Bool = true) -> Reducer<State, Action> {
        Reducer { state, action in
            var messages = [String]()
            messages.append("------------------")
            messages.append("receiving \(action)")
            let beforeState = state
            if before && !actionOnly {
                var before = String()
                dump(state, to: &before)
                messages.append("before: \(before)")
            }
            let effect = self.run(&state, action)
            if after && !actionOnly {
                messages.append("------")
                var after = String()
                if state == beforeState {
                    messages.append("after: no changes")
                } else {
                    dump(state, to: &after)
                    messages.append("after: \(after)")
                }
            }
            return .merge(effect, .fireAndForget {
                messages.forEach { print($0)
            }})
        }
    }
    
    func onChange<ScopedState: Equatable>(
        state scopedState: @escaping (State) -> ScopedState,
        update: @escaping (inout State, ScopedState) -> Void
    ) -> Reducer {
        Reducer { state, action in
            let beforeScopedState = scopedState(state)
            let effect = self.run(&state, action)
            let afterScopedState = scopedState(state)
            if beforeScopedState != afterScopedState {
                update(&state, afterScopedState)
            }
            return effect
        }
    }
    
    static func combine(_ reducers: [Reducer]) -> Reducer {
        Reducer { state, action in
            let effects = reducers.reduce([]) { effects, reducer in
                effects + [reducer.run(&state, action)]
            }
            return .merge(effects)
        }
    }
    
    static func combine(_ reducers: Reducer...) -> Reducer {
        return combine(reducers)
    }
    
    static func empty() -> Reducer {
        Reducer { state, action in
            return .none
        }
    }
    
    static func scope<LocalAction>(
        toLocal: @escaping (Action) -> LocalAction?,
        toAction: @escaping (LocalAction) -> Action,
        _ localReducer: Reducer<State, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            guard let localAction = toLocal(action) else {
                return .none
            }
            let effect = localReducer.run(&state, localAction)
            return effect.map(toAction)
        }
    }
    
    static func scope<LocalState, LocalAction>(
        state keyPath: WritableKeyPath<State, LocalState>,
        action caseKeyPath: CaseKeyPath<Action, LocalAction>,
        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            var localState = state[keyPath: keyPath]
            let effect = localReducer().run(&localState, localAction)
            state[keyPath: keyPath] = localState
            return effect.map(casePath.embed)
        }
    }
    
    static func ifLet<LocalState, LocalAction>(
        state keyPath: WritableKeyPath<State, LocalState?>,
        action caseKeyPath: CaseKeyPath<Action, LocalAction>,
        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            guard var localState = state[keyPath: keyPath] else {
                return .none
            }
            let effect = localReducer().run(&localState, localAction)
            state[keyPath: keyPath] = localState
            return effect.map(casePath.embed)
        }
    }
    
    static func forEach<LocalState, LocalAction, ID: Hashable>(
        state keyPath: WritableKeyPath<State, [LocalState]>,
        action caseKeyPath: CaseKeyPath<Action, (LocalAction, ID)>,
        id: @escaping (LocalState) -> ID,
        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            guard var localState = state[keyPath: keyPath].first(where: { id($0) == localAction.1 }) else {
                return .none
            }
            
            let effect = localReducer().run(&localState, localAction.0)
            state[keyPath: keyPath] = state[keyPath: keyPath].map {
                if id($0) == id(localState) {
                    return localState
                }
                return $0
            }
            return effect.map { effectLocalAction in
                casePath.embed((effectLocalAction, localAction.1))
            }
        }
    }
    
    static func forEach<LocalState, LocalAction, ID: Hashable>(
        state keyPath: WritableKeyPath<State, IdentifiedArrayOf<LocalState>>,
        action caseKeyPath: CaseKeyPath<Action, (LocalAction, ID)>,
        id: @escaping (LocalState) -> ID,
        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            guard var localState = state[keyPath: keyPath].first(where: { id($0) == localAction.1 }) else {
                return .none
            }
            
            let effect = localReducer().run(&localState, localAction.0)
            state[keyPath: keyPath] = IdentifiedArray(uniqueElements: state[keyPath: keyPath].map {
                if id($0) == id(localState) {
                    return localState
                }
                return $0
            })
            return effect.map { effectLocalAction in
                casePath.embed((effectLocalAction, localAction.1))
            }
        }
    }
}
