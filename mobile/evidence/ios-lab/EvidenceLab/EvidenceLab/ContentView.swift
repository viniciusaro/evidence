import Combine
import CasePaths
import SwiftUI

#Preview {
    ContentView(
        store: Store(
            initialState: AppState(),
            reducer: appReducer
        )
    )
}

let chatsUpdate = [
    Chat(
        name: "Lili ❤️‍🔥",
        messages: [
            Message(content: "Oi amor"),
            Message(content:
                "https://medium.com/@nqtuan86/clean-mac-storage-for-xcodes-users-5fbb32239aa5"
            ),
        ]
    ),
    Chat(
        name: "Grupo da Família",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Nossas Receitas",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Infinito particular",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Snow dos brothers 2024",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
]

let appReducer = Reducer<AppState, AppAction>.combine(
    .scope(\.rootAction) {
        Reducer { state, action in
            switch action {
            case .appLoad:
                return .none
            }
        }
    },
    .scope(\.chatList) {
        chatListReducer
    }
)

let rootReducer = Reducer<AppState, RootAction> { state, action in
    switch action {
    case .appLoad:
        return .none
    }
}

let chatListReducer = Reducer<AppState, ChatListAction> { state, action in
    switch action {
    case .chatListLoad:
        state.chats = chatsUpdate
        return .none
    
    case .chatDetail(.update(id: let id)):
        let chat = state.chats.first(where: { $0.id == id })
        state.chatDetail = chat
        return .none
    
    case .chatDetail(.messageViewLoad(id: let messageId)):
        let chat = state.chatFromMessage(messageId)
        let url = chat.messages
            .map { URL(string: $0.content) }
            .filter { $0?.host() != nil }
            .map { $0! }
            .first
        
        let message = chat.messages
            .filter { URL(string: $0.content)?.host() != nil }
            .first
        
        if let url = url, message?.preview == nil {
            return .publisher(
                URLPreviewClient.live
                    .get(url)
                    .receive(on: DispatchQueue.main)
                    .filter { $0 != nil }
                    .map { $0! }
                    .map { Preview(image: $0.image, title: $0.title) }
                    .map { .chatDetail(.messagePreviewLoaded(id: message!.id, $0)) }
                    .eraseToAnyPublisher()
            )
        }
        return .none
    
    case let .chatDetail(.messagePreviewLoaded(id: messageId, preview)):
        if let chatIndex = state.chats.firstIndex(where: {
            $0.messages.first(where: { $0.id == messageId }) != nil
        }) {
            let chat = state.chats[chatIndex]
            if let messageIndex = chat.messages.firstIndex(where: { $0.id == messageId }) {
                state.chats[chatIndex].messages[messageIndex].preview = preview
            }
        }
        return .none
    }
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ChatListView(store: store)
            .onViewDidLoad {
                store.send(.rootAction(.appLoad))
            }
        }
    }
}

struct ChatListView: View {
    let store: Store<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.chats) { chat in
                    Button(action: {
                        viewStore.send(.chatList(.chatDetail(.update(id: chat.id))))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.messages.first?.content ?? "").font(.caption)
                        }
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Conversas")
            .navigationDestination(
                item: Binding(
                    get: { viewStore.chatDetail },
                    set: { chat in viewStore.send(.chatList(.chatDetail(.update(id: chat?.id))))}
                )) { chat in
                    ChatView(id: chat.id, store: store)
                }
            .onViewDidLoad {
                store.send(.chatList(.chatListLoad))
            }
        }
    }
}

struct ChatView: View {
    let id: UUID
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.state.chat(id).messages) { message in
                    MessageView(id: message.id, store: store)
                }
            }
            .listStyle(.plain)
            .navigationTitle(viewStore.state.chat(id).name)
        }
    }
}

struct MessageView: View {
    let id: UUID
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            let message = viewStore.state.message(id)
            
            VStack(alignment: .leading) {
                Text(message.content)
                if let preview = message.preview {
                    AsyncImage(url: preview.image) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .frame(height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                        } else {
                            VStack {}
                        }
                    }
                }
            }
            .onViewDidLoad {
                viewStore.send(.chatList(.chatDetail(.messageViewLoad(id: id))))
            }
        }
    }
}

struct WithViewStore<State, Action>: View {
    @ObservedObject private var viewStore: ViewStore<State, Action>
    private let viewBuilder: (ViewStore<State, Action>) -> any View
    
    init(
        store: Store<State, Action>,
        @ViewBuilder viewBuilder: @escaping (ViewStore<State, Action>) -> any View
    ) {
        self.viewStore = ViewStore(store: store)
        self.viewBuilder = viewBuilder
    }
    
    var body: some View {
        AnyView(self.viewBuilder(self.viewStore))
    }
}

@CasePathable
enum AppAction {
    case rootAction(RootAction)
    case chatList(ChatListAction)
}

@CasePathable
enum RootAction {
    case appLoad
}

@CasePathable
enum ChatListAction {
    case chatListLoad
    case chatDetail(ChatAction)
}

@CasePathable
enum ChatAction {
    case update(id: ChatID?)
    case messageViewLoad(id: MessageID)
    case messagePreviewLoaded(id: MessageID, Preview)
}

struct AppState {
    var chats: [Chat] = []
    var chatDetail: Chat?
    
    func chat(_ id: ChatID) -> Chat {
        chats.first(where: { $0.id == id })!
    }
    
    func chatFromMessage(_ id: MessageID) -> Chat {
        chats.first(where: { $0.messages.first(where: { $0.id == id }) != nil })!
    }
    
    func message(_ id: MessageID) -> Message {
        chats
            .first(where: { $0.messages.first(where: { $0.id == id }) != nil })!
            .messages.first(where: { $0.id == id })!
    }
}

typealias MessageID = UUID
typealias ChatID = UUID

struct Chat: Identifiable, Equatable, Hashable {
    let id = ChatID()
    let name: String
    var messages: [Message]
}

struct Message: Identifiable, Equatable, Hashable {
    let id = MessageID()
    let content: String
    var preview: Preview? = nil
}

struct Preview: Equatable, Hashable {
    let image: URL
    let title: String
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
    
    deinit {
        effectCancellables.forEach { $0.cancel() }
    }
}

struct Reducer<State, Action> {
    let run: (_ state: inout State, _ action: Action) -> Effect<Action>
}

extension Reducer {
    func debug(before: Bool = true, after: Bool = true) -> Reducer<State, Action> {
        Reducer { state, action in
            var messages = [String]()
            messages.append("receiving \(action)")
            if before {
                var before = String()
                dump(state, to: &before)
                messages.append("before: \(before)")
            }
            let effect = self.run(&state, action)
            if after {
                messages.append("------")
                var after = String()
                dump(state, to: &after)
                messages.append("after: \(after)")
            }
            return .merge(effect, .fireAndForget { 
                messages.forEach { print($0)
            }})
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
    
    static func scope<LocalAction>(
        _ caseKeyPath: CaseKeyPath<Action, LocalAction>,
        _ localReducer: @escaping () -> Reducer<State, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            let effect = localReducer().run(&state, localAction)
            return effect.map(casePath.embed)
        }
    }
}

struct Effect<Action> {
    let run: (@escaping (Action) -> Void) -> any EffectCancellable
}

extension Effect {
    func map<OtherAction>(_ transform: @escaping (Action) -> OtherAction) -> Effect<OtherAction> {
        return Effect<OtherAction> { send in
            return self.run { action in
                send(transform(action))
            }
        }
    }
}

protocol EffectCancellable: Identifiable {
    func cancel()
}

struct SomeEffectCancellable: EffectCancellable {
    private let _cancel: () -> Void
    let id = UUID()
    
    init(_ cancel: @escaping () -> Void) {
        self._cancel = cancel
    }
    
    func cancel() {
        _cancel()
    }
}

extension UUID: EffectCancellable, Identifiable {
    public var id: UUID { return self }
    func cancel() {}
}

extension AnyCancellable: EffectCancellable {}

extension Effect {
    static var none: Effect {
        Effect { _ in UUID() }
    }
    
    static func fireAndForget(_ computation: @escaping () -> Void) -> Effect {
        Effect { _ in
            computation()
            return UUID()
        }
    }
    
    static func publisher(_ publisher: AnyPublisher<Action, Never>) -> Effect {
        Effect { send in
            publisher.sink(receiveValue: send)
        }
    }
    
    static func merge(_ effects: [Effect]) -> Effect {
        Effect { send in
            var cancellables = [any EffectCancellable]()
            for effect in effects {
                cancellables.append(effect.run(send))
            }
            return SomeEffectCancellable {
                cancellables.forEach { $0.cancel() }
            }
        }
    }
    
    static func merge(_ effects: Effect...) -> Effect {
        return merge(effects)
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}
