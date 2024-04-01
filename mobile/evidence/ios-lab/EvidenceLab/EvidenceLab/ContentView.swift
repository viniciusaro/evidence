//import Combine
//import CasePaths
//import SwiftUI
//
//#Preview {
//    ContentView(
//        store: Store(
//            initialState: AppState(),
//            reducer: appReducer
//        )
//    )
//}
//
//
//let appReducer = Reducer<AppState, AppAction>.combine(
//    Reducer { state, action in
//        if case .appLoad = action {
//            print("app load")
//        }
//        return .none
//    },
//    .scope(\.self, \.chatList) {
//        chatListReducer
//    }
//)
//
//let chatListReducer = Reducer<AppState, ChatListAction>.combine(
//    Reducer { state, action in
//        switch action {
//        case .chatListLoad:
//            state.chats = chatsUpdate
//            return .none
//        case .chatDetailDestination(id: let id):
//            let chat = state.chats.first(where: { $0.id == id })
//            state.chatDetail = chat
//            return .none
//        case .chatDetail(.messagePreviewLoaded):
//            return .none
//        case .chatDetail(_):
//            return .none
//        }
//    },
//    .ifLet(\.chatDetail, \.chatDetail) {
//        chatReducer
//    }
//)
//
//let chatReducer = Reducer<Chat, ChatAction> { state, action in
//    switch action {
//    case .messageViewLoad(id: let messageId):
//        let url = state.messages
//            .map { URL(string: $0.content) }
//            .filter { $0?.host() != nil }
//            .map { $0! }
//            .first
//        
//        let message = state.messages
//            .filter { URL(string: $0.content)?.host() != nil }
//            .first
//        
//        if let url = url, message?.preview == nil {
//            return .publisher(
//                URLPreviewClient.live
//                    .get(url)
//                    .receive(on: DispatchQueue.main)
//                    .filter { $0 != nil }
//                    .map { $0! }
//                    .map { Preview(image: $0.image, title: $0.title) }
//                    .map { .messagePreviewLoaded(id: message!.id, $0) }
//                    .eraseToAnyPublisher()
//            )
//        }
//        return .none
//    
//    case let .messagePreviewLoaded(id: messageId, preview):
//        if let messageIndex = state.messages.firstIndex(where: { $0.id == messageId }) {
//            state.messages[messageIndex].preview = preview
//        }
//        return .none
//    }
//}
//
//struct ContentView: View {
//    let store: Store<AppState, AppAction>
//    
//    var body: some View {
//        NavigationStack {
//            ChatListView(store: store)
//            .onViewDidLoad {
//                store.send(.appLoad)
//            }
//        }
//    }
//}
//
//struct ChatListView: View {
//    let store: Store<AppState, AppAction>
//    
//    var body: some View {
//        WithViewStore(store: store) { viewStore in
//            List {
//                ForEach(viewStore.chats) { chat in
//                    Button(action: {
//                        viewStore.send(.chatList(.chatDetailDestination(id: chat.id)))
//                    }, label: {
//                        VStack(alignment: .leading) {
//                            Text(chat.name)
//                            Text(chat.messages.first?.content ?? "").font(.caption)
//                        }
//                    })
//                }
//            }
//            .listStyle(.plain)
//            .navigationTitle("Conversas")
//            .navigationDestination(
//                item: Binding(
//                    get: { viewStore.chatDetail },
//                    set: { chat in viewStore.send(.chatList(.chatDetailDestination(id: chat?.id))) }
//                )) { chat in
//                    ChatView(id: chat.id, store: store)
//                }
//            .onViewDidLoad {
//                store.send(.chatList(.chatListLoad))
//            }
//        }
//    }
//}
//
//struct ChatView: View {
//    let id: UUID
//    let store: Store<AppState, AppAction>
//    
//    var body: some View {
//        WithViewStore(store: store) { viewStore in
//            List {
//                ForEach(viewStore.state.chat(id).messages) { message in
//                    MessageView(id: message.id, store: store)
//                }
//            }
//            .listStyle(.plain)
//            .navigationTitle(viewStore.state.chat(id).name)
//        }
//    }
//}
//
//struct MessageView: View {
//    let id: UUID
//    let store: Store<AppState, AppAction>
//    
//    var body: some View {
//        WithViewStore(store: store) { viewStore in
//            let message = viewStore.state.message(id)
//            
//            VStack(alignment: .leading) {
//                Text(message.content)
//                if let preview = message.preview {
//                    AsyncImage(url: preview.image) { phase in
//                        if let image = phase.image {
//                            image.resizable()
//                                .frame(height: 100)
//                                .aspectRatio(contentMode: .fit)
//                                .clipped()
//                        } else {
//                            VStack {}
//                        }
//                    }
//                }
//            }
//            .onViewDidLoad {
//                viewStore.send(.chatList(.chatDetail(.messageViewLoad(id: id))))
//            }
//        }
//    }
//}
//
//struct WithViewStore<State, Action>: View {
//    @ObservedObject private var viewStore: ViewStore<State, Action>
//    private let viewBuilder: (ViewStore<State, Action>) -> any View
//    
//    init(
//        store: Store<State, Action>,
//        @ViewBuilder viewBuilder: @escaping (ViewStore<State, Action>) -> any View
//    ) {
//        self.viewStore = ViewStore(store: store)
//        self.viewBuilder = viewBuilder
//    }
//    
//    var body: some View {
//        AnyView(self.viewBuilder(self.viewStore))
//    }
//}
//
//@CasePathable
//enum AppAction {
//    case appLoad
//    case chatList(ChatListAction)
//}
//
//@CasePathable
//enum ChatListAction {
//    case chatListLoad
//    case chatDetailDestination(id: ChatID?)
//    case chatDetail(ChatAction)
//}
//
//@CasePathable
//enum ChatAction {
//    case messageViewLoad(id: MessageID)
//    case messagePreviewLoaded(id: MessageID, Preview)
//}
//
//struct AppState {
//    var chats: [Chat] = []
//    var chatDetail: Chat?
//    
//    func chat(_ id: ChatID) -> Chat {
//        chats.first(where: { $0.id == id })!
//    }
//    
//    func chatFromMessage(_ id: MessageID) -> Chat {
//        chats.first(where: { $0.messages.first(where: { $0.id == id }) != nil })!
//    }
//    
//    func message(_ id: MessageID) -> Message {
//        chats
//            .first(where: { $0.messages.first(where: { $0.id == id }) != nil })!
//            .messages.first(where: { $0.id == id })!
//    }
//}
//
//
//@dynamicMemberLookup
//class ViewStore<State, Action>: ObservableObject {
//    @Published var state: State
//    private var storeSinkCancellable: AnyCancellable?
//    private(set) var send: (Action) -> Void
//    
//    init(store: Store<State, Action>) {
//        self.state = store.state
//        self.send = store.send
//        self.storeSinkCancellable = store.$state.sink { [weak self] update in
//            self?.state = update
//        }
//    }
//    
//    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
//        return state[keyPath: keyPath]
//    }
//    
//    deinit {
//        self.storeSinkCancellable?.cancel()
//    }
//}
//
//class Store<State, Action> {
//    @Published fileprivate var state: State
//    private let reducer: Reducer<State, Action>
//    private var effectCancellables: [any EffectCancellable] = []
//    
//    init(initialState: State, reducer: Reducer<State, Action>) {
//        self.state = initialState
//        self.reducer = reducer
//    }
//    
//    func send(_ action: Action) {
//        let effect = reducer.run(&state, action)
//        effectCancellables.append(effect.run(send))
//    }
//    
//    func scope<LocalState, LocalAction>(
//        state keyPath: WritableKeyPath<State, LocalState>,
//        action toAction: CaseKeyPath<Action, LocalAction>
//    ) -> Store<LocalState, LocalAction> {
//        Store<LocalState, LocalAction>(
//            initialState: state[keyPath: keyPath],
//            reducer: Reducer { localState, localAction in
//                let action = toAction(localAction)
//                self.send(action)
//                localState = self.state[keyPath: keyPath]
//                return .none
//            }
//        )
//    }
//    
//    deinit {
//        effectCancellables.forEach { $0.cancel() }
//    }
//}
//
//struct Reducer<State, Action> {
//    let run: (_ state: inout State, _ action: Action) -> Effect<Action>
//}
//
//extension Reducer {
//    func debug(actionOnly: Bool = false, before: Bool = true, after: Bool = true) -> Reducer<State, Action> {
//        Reducer { state, action in
//            var messages = [String]()
//            
//            messages.append("------------------")
//            messages.append("receiving \(action)")
//            if before && !actionOnly {
//                var before = String()
//                dump(state, to: &before)
//                messages.append("before: \(before)")
//            }
//            let effect = self.run(&state, action)
//            if after  && !actionOnly {
//                messages.append("------")
//                var after = String()
//                dump(state, to: &after)
//                messages.append("after: \(after)")
//            }
//            return .merge(effect, .fireAndForget { 
//                messages.forEach { print($0)
//            }})
//        }
//    }
//    
//    static func combine(_ reducers: [Reducer]) -> Reducer {
//        Reducer { state, action in
//            let effects = reducers.reduce([]) { effects, reducer in
//                effects + [reducer.run(&state, action)]
//            }
//            return .merge(effects)
//        }
//    }
//    
//    static func combine(_ reducers: Reducer...) -> Reducer {
//        return combine(reducers)
//    }
//    
//    static func scope<LocalAction>(
//        toLocal: @escaping (Action) -> LocalAction?,
//        toAction: @escaping (LocalAction) -> Action,
//        _ localReducer: Reducer<State, LocalAction>
//    ) -> Reducer {
//        Reducer { state, action in
//            guard let localAction = toLocal(action) else {
//                return .none
//            }
//            let effect = localReducer.run(&state, localAction)
//            return effect.map(toAction)
//        }
//    }
//    
//    static func scope<LocalState, LocalAction>(
//        _ keyPath: WritableKeyPath<State, LocalState>,
//        _ caseKeyPath: CaseKeyPath<Action, LocalAction>,
//        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
//    ) -> Reducer {
//        Reducer { state, action in
//            let casePath = AnyCasePath(caseKeyPath)
//            guard let localAction = casePath.extract(from: action) else {
//                return .none
//            }
//            var localState = state[keyPath: keyPath]
//            let effect = localReducer().run(&localState, localAction)
//            state[keyPath: keyPath] = localState
//            return effect.map(casePath.embed)
//        }
//    }
//    
//    static func ifLet<LocalState, LocalAction>(
//        _ keyPath: WritableKeyPath<State, LocalState?>,
//        _ caseKeyPath: CaseKeyPath<Action, LocalAction>,
//        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
//    ) -> Reducer {
//        Reducer { state, action in
//            let casePath = AnyCasePath(caseKeyPath)
//            guard let localAction = casePath.extract(from: action) else {
//                return .none
//            }
//            guard var localState = state[keyPath: keyPath] else {
//                return .none
//            }
//            let effect = localReducer().run(&localState, localAction)
//            state[keyPath: keyPath] = localState
//            return effect.map(casePath.embed)
//        }
//    }
//}
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
//    static func fireAndForget(_ computation: @escaping () -> Void) -> Effect {
//        Effect { _ in
//            computation()
//            return UUID()
//        }
//    }
//    
//    static func publisher(_ publisher: AnyPublisher<Action, Never>) -> Effect {
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
//
