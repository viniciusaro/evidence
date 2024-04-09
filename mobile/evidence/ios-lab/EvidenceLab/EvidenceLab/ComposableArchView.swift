import ComposableArchitecture
import SwiftUI

#Preview {
    ChatListViewArch(
        store: Store(initialState: ChatListFeatureArch.State()) {
            ChatListFeatureArch()
        }
    )
}

@Reducer
struct RootFeatureArch {
    @ObservableState
    struct State: Equatable {
        var home: HomeFeatureArch.State
        var profile: ProfileFeatureArch.State
        var count: Int = 0
    }
    
    @CasePathable
    enum Action {
        case home(HomeFeatureArch.Action)
        case profile(ProfileFeatureArch.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

@Reducer
struct HomeFeatureArch {
    @ObservableState
    struct State: Equatable {
        var count: Int
    }
    
    @CasePathable
    enum Action {
        case load
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

@Reducer
struct ProfileFeatureArch {
    @ObservableState
    struct State: Equatable {
        var count: Int
    }
    
    @CasePathable
    enum Action {
        case load
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

@Reducer
struct ChatListFeatureArch {
    @ObservableState
    struct State: Equatable {
        var chats: [ChatDetailFeatureArch.State] = []
        @Presents var chatDetail: ChatDetailFeatureArch.State?
    }
    
    enum Action {
        case chatListLoad
        case chatListLoaded([Chat])
        case chatListItemTapped(ChatDetailFeatureArch.State)
        case chatDetail(PresentationAction<ChatDetailFeatureArch.Action>)
    }
        
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .chatListLoad:
                return .publisher {
                    ChatClient.mock.getAll()
                        .map { .chatListLoaded($0) }
                }
                
            case let .chatListLoaded(chats):
                state.chats = chats.map { ChatDetailFeatureArch.State(chat:$0) }
                return .none
            
            case let .chatListItemTapped(chatDetailState):
                state.chatDetail = chatDetailState
                return .none
                
            case let .chatDetail(action):
                switch action {
                case .dismiss:
                    state.chatDetail = nil
                case .presented:
                    break
                }
                return .none
            }
        }
        .ifLet(\.$chatDetail, action: \.chatDetail) {
            ChatDetailFeatureArch()
        }
    }
}

@Reducer
struct ChatDetailFeatureArch {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: ChatID
        var name: String
        var messages: IdentifiedArrayOf<MessageFeatureArch.State>
        
        init(chat: Chat) {
            self.id = chat.id
            self.name = chat.name
            self.messages = IdentifiedArray(
                uniqueElements: chat.messages.map { MessageFeatureArch.State(message: $0) }
            )
        }
    }
    enum Action {
        case messages(IdentifiedActionOf<MessageFeatureArch>)
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer().forEach(\.messages, action: \.messages) {
            MessageFeatureArch()
        }
    }
}

@Reducer
struct MessageFeatureArch {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: MessageID
        var content: String
        var preview: Preview?
        
        init(message: Message) {
            self.id = message.id
            self.content = message.content
            self.preview = nil
        }
    }
    
    enum Action {
        case messageViewLoad
        case messagePreviewLoaded(Preview)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .messageViewLoad:
                guard 
                    let url = URL(string: state.content),
                    url.host() != nil, 
                    state.preview == nil else {
                    return .none
                }
                
                return .publisher {
                    URLPreviewClient.live
                        .get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .messagePreviewLoaded($0) }
                        .eraseToAnyPublisher()
                }
                
            case let .messagePreviewLoaded(preview):
                state.preview = preview
                return .none
            }
        }
    }
}

struct RootViewArch: View {
    let store: StoreOf<RootFeatureArch>
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeViewArch(store: store.scope(state: \.home, action: \.home))
                ProfileViewArch(store: store.scope(state: \.profile, action: \.profile))
            }
        }
    }
}

struct HomeViewArch: View {
    let store: StoreOf<HomeFeatureArch>
    
    var body: some View {
        Text("Home: \(store.count)")
    }
}

struct ProfileViewArch: View {
    let store: StoreOf<ProfileFeatureArch>
    
    var body: some View {
        Text("Profile \(store.count)")
    }
}

struct ChatListViewArch: View {
    @Bindable var store: StoreOf<ChatListFeatureArch>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.chats) { chat in
                    Button(action: {
                        store.send(.chatListItemTapped(chat))
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
            .navigationDestination(item: $store.scope(state: \.chatDetail, action: \.chatDetail)) {
                ChatDetailViewArch(store: $0)
            }
            .onViewDidLoad {
                store.send(.chatListLoad)
            }
        }
    }
}

struct ChatDetailViewArch: View {
    let store: StoreOf<ChatDetailFeatureArch>
    
    var body: some View {
        List {
            ForEach(store.scope(state: \.messages, action: \.messages)) {
                MessageViewArch(store: $0)
            }
        }
        .listStyle(.plain)
        .navigationTitle(store.name)
    }
}

struct MessageViewArch: View {
    let store: StoreOf<MessageFeatureArch>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(store.content)
            if let preview = store.preview {
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
            store.send(.messageViewLoad)
        }
    }
}

@propertyWrapper
class Shared<Value> {
    var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    var projectedValue: Shared {
        self
    }
}

@propertyWrapper
class SharedArray<Value> {
    var wrappedValue: [Shared<Value>]
    
    init(wrappedValue: [Shared<Value>]) {
        self.wrappedValue = wrappedValue
    }
    
    init(_ array: [Value]) {
        self.wrappedValue = array.map { Shared(wrappedValue: $0) }
    }
    
    subscript(_ index: Int) -> Value {
        wrappedValue[index].wrappedValue
    }
}

extension SharedArray: Collection {
    subscript(position: Int) -> Shared<Value> {
        _read {
            yield wrappedValue[position]
        }
    }
    
    typealias Element = Shared<Value>
    
    func index(after i: Int) -> Int {
        wrappedValue.index(after: i)
    }
    
    var startIndex: Int {
        wrappedValue.startIndex
    }
    
    var endIndex: Int {
        wrappedValue.endIndex
    }
}

extension Shared: Equatable where Value: Equatable {
    static func == (lhs: Shared<Value>, rhs: Shared<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Shared: Hashable where Value: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue.hashValue)
    }
}

extension SharedArray: Equatable where Value: Equatable {
    static func == (lhs: SharedArray<Value>, rhs: SharedArray<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension SharedArray: Hashable where Value: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue.hashValue)
    }
}
