import Combine
import CasePaths
import SwiftUI

let authClient = AuthClient.authenticated()
let chatClient = ChatClient.filesystem
let chatDocumentClient = AnyDocumentClient<Chat>.file("chats")

#Preview {
    buildRootView()
}

func buildRootView() -> any View {
    RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: RootFeature.reducer
        )
    )
}

struct RootFeature: Feature {
    struct State: Equatable {
        var home: HomeFeature.State = .init()
        var login: LoginFeature.State? = nil
    }
    
    @CasePathable
    enum Action {
        case rootLoad
        case currentUserUpdate(User?)
        case home(HomeFeature.Action)
        case login(LoginFeature.Action)
        case unauthenticatedUserModalDismissed
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .rootLoad:
                return .publisher(
                    authClient.getAuthenticatedUser()
                        .map { .currentUserUpdate($0) }
                        .receive(on: DispatchQueue.main)
                )
                
            case let .currentUserUpdate(user):
                state.login = user == nil ? LoginFeature.State() : nil
                return .none
                
            case .unauthenticatedUserModalDismissed:
                return .none
                
            case let .home(.chatDetail(.sent(chatId, messageId))):
                guard let chat = state.home.chatDetail else {
                    return .none
                }
                
                if let index = chat.messages.firstIndex(where: { $0.id == messageId }) {
                    state.home.chatDetail?.messages[index].isSent = true
                }
                return .none
            
            case let .home(.newChatCreated(chat)):
                state.home.chatList.chats.insert(ChatDetailFeature.State(chat: chat), at: 0)
                return .none
                
            case .home(.chatDetailNavigation(_)):
                guard let chatDetail = state.home.chatDetail else {
                    return .none
                }
                let chatIndex = state.home.chatIndex(id: chatDetail.id)
                state.home.chatList.chats[chatIndex] = chatDetail
                return .none
                
            case .home:
                return .none
                
            case .login:
                return .none
            }
        },
        .scope(state: \.home, action: \.home) {
            HomeFeature.reducer
        },
        .ifLet(state: \.login, action: \.login) {
            LoginFeature.reducer
        }
    )
}

struct LoginFeature: Feature {
    struct State: Equatable, Identifiable {
        let id = UUID()
    }
    
    @CasePathable
    enum Action {
        case submitButtonTapped(String, String)
        case userAuthenticated(User)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .submitButtonTapped(username, password):
                return .publisher(
                    authClient.authenticate(username, password)
                        .map { .userAuthenticated($0) }
                )
            case .userAuthenticated:
                return .none
            }
        }
    )
}

struct HomeFeature: Feature {
    struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var chatDetail: ChatDetailFeature.State? = nil
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        
        enum Tab: String {
            case chatList = "Conversas"
            case profile = "Perfil"
            
            var title: String {
                return rawValue.capitalized
            }
        }
        
        func chatIndex(id: ChatID) -> Int {
            chatList.chats.firstIndex(where: { $0.id == id })!
        }
    }
    
    @CasePathable
    enum Action {
        case onTabSelectionChanged(State.Tab)
        case chatList(ChatListFeature.Action)
        case chatDetail(ChatDetailFeature.Action)
        case chatDetailNavigation(ChatDetailFeature.State?)
        case newChatItemTapped
        case newChatCreated(Chat)
        case profile(ProfileFeature.Action)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .onTabSelectionChanged(selection):
                state.selectedTab = selection
                return .none
            
            case let .chatList(.chatListItemTapped(chatDetailState)):
                state.chatDetail = chatDetailState
                return .none
            
            case .chatList:
                return .none
            
            case .chatDetail:
                return .none
            
            case let .chatDetailNavigation(chatDetailState):
                state.chatDetail = chatDetailState
                return .none
            
            case .newChatItemTapped:
                return .publisher(
                    chatClient.new("Lili")
                        .map { .newChatCreated($0) }
                )
            
            case let .newChatCreated(chat):
                return .none
                
            case .profile:
                return .none
            }
        },
        .scope(state: \.chatList, action: \.chatList) {
            ChatListFeature.reducer
        },
        .ifLet(state: \.chatDetail, action: \.chatDetail) {
            ChatDetailFeature.reducer
        },
        .scope(state: \.profile, action: \.profile) {
            ProfileFeature.reducer
        }
    )
}

struct ProfileFeature: Feature {
    struct State: Equatable {
        var currentUser: User?
    }
    
    @CasePathable
    enum Action {
        case profileLoad
        case currentUserUpdate(User?)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .profileLoad:
                return .publisher(
                    authClient.getAuthenticatedUser()
                        .map { .currentUserUpdate($0) }
                )
            
            case let .currentUserUpdate(user):
                state.currentUser = user
                return .none
            }
        }
    )
}

struct ChatListFeature: Feature {
    struct State: Equatable {
        var chats: [ChatDetailFeature.State] = []
        
        init(chats: [Chat] = []) {
            self.chats = chats.map { ChatDetailFeature.State(chat:$0) }
        }
    }
    
    @CasePathable
    enum Action {
        case chatListLoad
        case chatListLoaded([Chat])
        case chatListItemTapped(ChatDetailFeature.State)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .chatListLoad:
                return .publisher(
                    chatClient.getAll()
                        .map { .chatListLoaded($0) }
                )
                
            case let .chatListLoaded(chats):
                state.chats = chats.map { ChatDetailFeature.State(chat:$0) }
                return .none
                
            case .chatListItemTapped:
                return .none
            }
        }
    )
}

struct ChatDetailFeature: Feature {
    struct State: Equatable, Identifiable, Hashable {
        let id: ChatID
        var name: String
        var messages: [MessageFeature.State]
        var inputText: String
        
        init(chat: Chat, inputText: String = "") {
            self.id = chat.id
            self.name = chat.name
            self.messages = chat.messages.map { MessageFeature.State(message: $0) }
            self.inputText = inputText
        }
    }
    
    @CasePathable
    enum Action {
        case message(MessageFeature.Action, MessageFeature.State.ID)
        case updateInputText(String)
        case send
        case sent(ChatID, MessageID)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .message:
                return .none
            
            case let .updateInputText(update):
                state.inputText = update
                return .none
                
            case .send:
                let newMessage = Message(content: state.inputText)
                let newMessageState = MessageFeature.State(message: newMessage, isSent: false)
                let chatId = state.id
                
                state.messages.append(newMessageState)
                state.inputText = ""
                
                return .publisher(
                    chatClient.send(newMessage, state.id)
                        .map { .sent(chatId, newMessage.id) }
                )
            case .sent:
                return .none
            }
        },
        .forEach(state: \.messages, action: \.message) {
            MessageFeature.reducer
        }
    )
}

struct MessageFeature: Feature {
    struct State: Equatable, Identifiable, Hashable {
        let id: MessageID
        var content: String
        var preview: Preview?
        var isSent: Bool
        
        init(message: Message, isSent: Bool = true) {
            self.id = message.id
            self.content = message.content
            self.preview = nil
            self.isSent = isSent
        }
    }
    
    @CasePathable
    enum Action {
        case messageViewLoad
        case messagePreviewLoaded(Preview)
    }
    
    fileprivate static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .messageViewLoad:
                guard
                    let url = URL(string: state.content),
                    url.host() != nil,
                    state.preview == nil else {
                    return .none
                }
                
                return .publisher(
                    URLPreviewClient.live
                        .get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .messagePreviewLoaded($0) }
                    )
                
            case let .messagePreviewLoaded(preview):
                state.preview = preview
                return .none
            }
        }
    )
}

struct RootView: View {
    fileprivate let store: StoreOf<RootFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            HomeView(
                store: store.scope(state: \.home, action: \.home)
            )
            .onViewDidLoad {
                viewStore.send(.rootLoad)
            }
            .sheet(item: Binding(
                get: { viewStore.login },
                set: { _ in viewStore.send(.unauthenticatedUserModalDismissed) }
            )) { loginState in
                LoginView(store: store.scope(state: { _ in loginState }, action: \.login))
            }
        }
    }
}

struct LoginView: View {
    fileprivate let store: StoreOf<LoginFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            Button(action: {
                viewStore.send(.submitButtonTapped("user", "password"))
            }, label: {
                Text("Entrar")
            })
        }
    }
}

struct HomeView: View {
    fileprivate let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            NavigationStack {
                TabView(
                    selection: Binding(
                        get: { viewStore.selectedTab },
                        set: { viewStore.send(.onTabSelectionChanged($0)) }
                    )
                ) {
                    ChatListView(store: store.scope(state: \.chatList, action: \.chatList))
                        .tabItem {
                            Label(
                                HomeFeature.State.Tab.chatList.title,
                                systemImage: "bubble.right"
                            )
                        }
                        .tag(HomeFeature.State.Tab.chatList)
                        
                    ProfileView(store: store.scope(state: \.profile, action: \.profile))
                        .tabItem {
                            Label(
                                HomeFeature.State.Tab.profile.title,
                                systemImage: "brain.filled.head.profile"
                            )
                        }
                        .tag(HomeFeature.State.Tab.profile)
                }
                .navigationDestination(
                    item: Binding(
                        get: { viewStore.chatDetail },
                        set: { viewStore.send(.chatDetailNavigation($0))}
                    )
                ) { chatDetail in
                    ChatDetailView(
                        store: store.scope(state: { _ in chatDetail }, action: \.chatDetail)
                    )
                }
                .navigationTitle(viewStore.selectedTab.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(action: {
                        viewStore.send(.newChatItemTapped)
                    }, label: {
                        Label("", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .font(.title)
                            .foregroundStyle(.primary)
                    })
                }
            }
        }
    }
}

struct ProfileView: View {
    fileprivate let store: StoreOf<ProfileFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack {
                if let currentUser = viewStore.currentUser {
                    Text("PROFILE OF \(currentUser.name)")
                } else {
                    Text("NO ONE'S PROFILE")
                }
            }
            .onViewDidLoad {
                viewStore.send(.profileLoad)
            }
        }
    }
}

struct ChatListView: View {
    fileprivate let store: Store<ChatListFeature.State, ChatListFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.chats) { chat in
                    Button(action: {
                        viewStore.send(.chatListItemTapped(chat))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.messages.last?.content ?? "").font(.caption)
                        }
                    })
                }
            }
            .listStyle(.plain)
            .onViewDidLoad {
                viewStore.send(.chatListLoad)
            }
        }
    }
}

struct ChatDetailView: View {
    fileprivate let store: Store<ChatDetailFeature.State, ChatDetailFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack {
                List {
                    ForEach(viewStore.messages) { message in
                        MessageView(store: store.scope(state: { _ in message }, action: \.message))
                    }
                }
                .listStyle(.plain)
                HStack(spacing: 12) {
                    Button(action: {
                        
                    }, label: {
                        Label("", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .font(.title)
                            .foregroundStyle(.primary)
                    })
                    TextField("", text: Binding(
                        get: { viewStore.inputText },
                        set: { viewStore.send(.updateInputText($0)) }
                    ))
                    .frame(height: 36)
                    .padding([.leading, .trailing], 8)
                    .background(RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                    )
                    Button(action: {
                        viewStore.send(.send)
                    }, label: {
                        Label("", systemImage: "arrow.forward.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.largeTitle)
                            .foregroundStyle(.white, .primary)
                    })
                }
                .padding(10)
                .background(Color(red: 20/255, green: 20/255, blue: 20/255))
            }
            .navigationTitle(viewStore.name)
        }
    }
}

struct MessageView: View {
    fileprivate let store: Store<MessageFeature.State, MessageFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text(viewStore.content)
                    Spacer()
                    if viewStore.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
                if let preview = viewStore.preview {
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
                viewStore.send(.messageViewLoad)
            }
        }
    }
}

fileprivate struct WithViewStore<State, Action>: View {
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

@dynamicMemberLookup
fileprivate class ViewStore<State, Action>: ObservableObject {
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

fileprivate typealias StoreOf<F: Feature> = Store<F.State, F.Action>

fileprivate class Store<State, Action> {
    @Published fileprivate var state: State
    private let reducer: Reducer<State, Action>
    private var effectCancellables: [any EffectCancellable] = []
    
    fileprivate init(initialState: State, reducer: Reducer<State, Action>) {
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

fileprivate struct Reducer<State, Action> {
    let run: (_ state: inout State, _ action: Action) -> Effect<Action>
}

fileprivate typealias ReducerOf<F: Feature> = Reducer<F.State, F.Action>

fileprivate protocol Feature {
    associatedtype State
    associatedtype Action
}

extension Reducer {
    func debug(actionOnly: Bool = false, before: Bool = true, after: Bool = true) -> Reducer<State, Action> {
        Reducer { state, action in
            var messages = [String]()
            messages.append("------------------")
            messages.append("receiving \(action)")
            if before && !actionOnly {
                var before = String()
                dump(state, to: &before)
                messages.append("before: \(before)")
            }
            let effect = self.run(&state, action)
            if after  && !actionOnly {
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
    
    static func forEach<LocalState: Identifiable, LocalAction>(
        state keyPath: WritableKeyPath<State, [LocalState]>,
        action caseKeyPath: CaseKeyPath<Action, (LocalAction, LocalState.ID)>,
        _ localReducer: @escaping () -> Reducer<LocalState, LocalAction>
    ) -> Reducer {
        Reducer { state, action in
            let casePath = AnyCasePath(caseKeyPath)
            guard let localAction = casePath.extract(from: action) else {
                return .none
            }
            guard var localState = state[keyPath: keyPath].first(where: { $0.id == localAction.1 }) else {
                return .none
            }
            
            let effect = localReducer().run(&localState, localAction.0)
            state[keyPath: keyPath] = state[keyPath: keyPath].map {
                if $0.id == localState.id {
                    return localState
                }
                return $0
            }
            return effect.map { effectLocalAction in
                casePath.embed((effectLocalAction, localAction.1))
            }
        }
    }
}

fileprivate struct Effect<Action> {
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
    
    static func sync(_ action: Action) -> Effect {
        publisher(Just(action))
    }
    
    static func fireAndForget(_ computation: @escaping () -> Void) -> Effect {
        Effect { _ in
            computation()
            return UUID()
        }
    }
    
    static func publisher(_ publisher: any Publisher<Action, Never>) -> Effect {
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

