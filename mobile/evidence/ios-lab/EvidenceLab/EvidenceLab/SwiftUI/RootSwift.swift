import Combine
import IdentifiedCollections
import SwiftUI

#Preview("Root") {
    authClient = AuthClient.authenticated()
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.live
    installationClient = InstallationClient.mock("1")

    return RootViewSwift(
        model: RootViewModel()
    )
}

#Preview("Home") {
    authClient = AuthClient.authenticated()
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.live
    installationClient = InstallationClient.mock("1")

    return HomeViewSwift(
        model: HomeViewModel(
            state: .init(selectedTab: .chatList)
        )
    )
}

enum RootViewState {
    case home(HomeViewModel)
    case login
}

@Observable
class RootViewModel {
    var state: RootViewState
    
    init() {
        if let _ = authClient.getAuthenticatedUser() {
            self.state = .home(HomeViewModel())
        } else {
            self.state = .login
        }
    }
}

struct RootViewSwift: View {
    let model: RootViewModel
    
    var body: some View {
        switch model.state {
        case let .home(homeModel):
            HomeViewSwift(model: homeModel)
        case .login:
            LoginViewSwift()
        }
    }
}

struct LoginViewSwift: View {
    var body: some View {
        Text("login")
    }
}

struct HomeViewState {
    var chatList: ChatListViewModel = .init()
    var selectedTab: Tab = .chatList
    
    enum Tab: String, Codable {
        case chatList = "Conversas"
        case profile = "Perfil"
        
        var title: String {
            return rawValue.capitalized
        }
    }
}

@Observable
class HomeViewModel {
    var state: HomeViewState
    
    init(state: HomeViewState = .init()) {
        self.state = state
    }
}

struct HomeViewSwift: View {
    @Bindable var model: HomeViewModel
    
    var body: some View {
        TabView(selection: $model.state.selectedTab) {
            ChatListViewSwift(model: model.state.chatList)
                .tabItem {
                    Label(
                        HomeViewState.Tab.chatList.title,
                        systemImage: "bubble.right"
                    )
                }
                .tag(HomeViewState.Tab.chatList)
            ProfileViewSwift()
                .tabItem {
                    Label(
                        HomeViewState.Tab.profile.title,
                        systemImage: "brain.filled.head.profile"
                    )
                }
                .tag(HomeViewState.Tab.profile)
        }
    }
}

struct ChatListState {
    var chats: IdentifiedArrayOf<ChatClass> = [] {
        didSet {
            print("update")
        }
    }
    var detail: ChatDetailModel? = nil
    
    init() {
        do {
            let data = try dataClient.load(.chats)
            let decoder = JSONDecoder()
            let chats = try decoder.decode(IdentifiedArrayOf<Chat>.self, from: data)
            self.chats = chats.map { ChatClass(from: $0) }.identified
        } catch {
            self.chats = []
        }
    }
}

@Observable
class ChatListViewModel {
    var state: ChatListState {
        didSet {
            print("update state")
        }
    }
    private var cancellable: AnyCancellable?
    
    init(state: ChatListState = .init()) {
        self.state = state
        self.consumePendingMessages()
    }
    
    private func consumePendingMessages() {
        self.cancellable = stockClient.consume()
            .sink(receiveValue: { chatUpdate in
                if let chat = self.state.chats[id: chatUpdate.id] {
                    self.state.chats[id: chat.id]?
                        .messages.append(contentsOf: chatUpdate.messages)
                } else {
                    self.state.chats.insert(ChatClass(from: chatUpdate), at: 0)
                }
            })
    }
    
    func onListItemTapped(_ chat: ChatClass) {
        state.detail = ChatDetailModel(chat: chat)
    }
}

struct ChatListViewSwift: View {
    @Bindable var model: ChatListViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.state.chats) { chat in
                    Button(action: {
                        model.onListItemTapped(chat)
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            if let content = chat.messages.last?.content {
                                Text(content).font(.caption)
                            }
                        }
                    })
                }
                .onDelete { indexSet in
    //                store.send(.onListItemDelete(indexSet))
                }
            }
            .animation(.bouncy, value: model.state.chats)
            .listStyle(.plain)
            .navigationDestination(item: $model.state.detail) { model in
                ChatDetailViewSwift(model: model)
            }
        }
    }
}

struct ChatDetailState: Equatable, Hashable {
    var chat: ChatClass
    var inputText: String = ""
}

@Observable
class ChatDetailModel {
    var state: ChatDetailState
    
    init(chat: ChatClass) {
        self.state = .init(chat: chat)
    }
    
    func onSendButtonTapped() {
        let newMessage = Message(content: state.inputText, sender: .cris)
        state.chat.messages.append(newMessage)
        state.inputText = ""
    }
}

extension ChatDetailModel: Equatable, Hashable {
    static func == (lhs: ChatDetailModel, rhs: ChatDetailModel) -> Bool {
        lhs.state == rhs.state
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(state)
    }
}

struct ChatDetailViewSwift: View {
    @Bindable var model: ChatDetailModel
    
    var body: some View {
        VStack {
            List {
                ForEach(model.state.chat.messages) { message in
                    Text(message.content)
                }
//                ForEach(store.scope(state: \.messages, action: \.message)) { store in
//                    MessageView(store: store)
//                }
            }
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(.primary)
                })
                TextField("", text: $model.state.inputText)
                .frame(height: 36)
                .padding([.leading, .trailing], 8)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                )
                Button(action: {
//                    store.send(.send)
                    model.onSendButtonTapped()
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
        .listStyle(.plain)
//        .navigationTitle(store.title)
    }
}

struct ProfileViewSwift: View {
//    @Environment(UserObject.self) var user
    
    var body: some View {
        Text("Profile")
    }
}
