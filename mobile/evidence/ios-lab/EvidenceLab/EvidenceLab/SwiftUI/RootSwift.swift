import Combine
import IdentifiedCollections
import SwiftUI

#Preview("ChatList 123") {
    authClient = AuthClient.authenticated()
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.mock(Chat.mockList, interval: 10000)
    installationClient = InstallationClient.mock("1")

    return HomeViewSwift()
}

enum Tab: String, Codable {
    case chatList = "Conversas"
    case profile = "Perfil"
    
    var title: String {
        return rawValue.capitalized
    }
}

@Observable
class ChatStore {
    var chats: [Chat] = []
    var detail: ChatID? = nil
    var user: User
    private var consumeCancellable: AnyCancellable?
    
    init() {
        do {
            let data = try dataClient.load(.chats)
            let decoder = JSONDecoder()
            self.chats = try decoder.decode([Chat].self, from: data)
        } catch {
            self.chats = []
        }
        self.user = authClient.getAuthenticatedUser() ?? User()
        self.consumePendingMessages()
    }
    
    private func consumePendingMessages() {
        self.consumeCancellable = stockClient.consume()
            .sink(receiveValue: { chatUpdate in
                if let index = self.chats.firstIndex(where: { $0.id == chatUpdate.id }) {
                    self.chats[index].messages.append(contentsOf: chatUpdate.messages)
                } else {
                    self.chats.insert(chatUpdate, at: 0)
                }
            })
    }
}

extension EnvironmentValues {
    var user: User {
        get { self[EnvironmentUserKey.self] }
        set { self[EnvironmentUserKey.self] = newValue }
    }
}

struct EnvironmentUserKey: EnvironmentKey {
    static var defaultValue = User()
}

struct HomeViewSwift: View {
    @Bindable var store = ChatStore()
    @State var selectedTab = Tab.chatList
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ChatListViewSwift(store: store)
                    .tabItem {
                        Label(
                            Tab.chatList.title,
                            systemImage: "bubble.right"
                        )
                    }
                    .tag(Tab.chatList)
                ProfileViewSwift()
                    .tabItem {
                        Label(
                            Tab.profile.title,
                            systemImage: "brain.filled.head.profile"
                        )
                    }
                    .tag(Tab.profile)
            }
            .navigationDestination(item: $store.detail) { id in
                let index = store.chats.firstIndex(where: { $0.id == id })!
                return ChatDetailViewSwift(chat: $store.chats[index], store: store)
            }
            .navigationTitle(selectedTab.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.user, store.user)
    }
}

struct ChatListViewSwift: View {
    @Bindable var store: ChatStore
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($store.chats) { $chat in
                    Button {
                        self.store.detail = chat.id
                    } label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            if let content = chat.messages.last?.content {
                                Text(content).font(.caption)
                            }
                        }
                    }
                }
            }
            .animation(.bouncy, value: store.chats)
            .listStyle(.plain)
        }
    }
}

struct ChatDetailViewSwift: View {
    @Binding var chat: Chat
    @State var inputText: String = ""
    let store: ChatStore

    var body: some View {
        VStack {
            List {
                ForEach($chat.messages) { $message in
                    MessageViewSwift(message: $message)
                }
            }
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(.primary)
                })
                TextField("", text: $inputText)
                .frame(height: 36)
                .padding([.leading, .trailing], 8)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                )
                Button(action: {
                    chat.messages.append(Message(content: inputText, sender: .vini))
                    inputText = ""
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
        .navigationTitle(chat.name)
    }
}

@Observable
class MessageStore {
    private var previewCancellables: Set<AnyCancellable> = []
    
    func onMessageLoad(_ message: Message, _ onComplete: @escaping (Message) -> Void) {
        guard
            let url = URL(string: message.content),
            url.host() != nil,
            message.preview == nil else {
            return
        }
        print("on message loaded: \(message)")
        var copy = message
        
        URLPreviewClient.live
            .get(url)
            .receive(on: DispatchQueue.main)
            .filter { $0 != nil }
            .map { $0! }
            .map { Preview(image: $0.image, title: $0.title) }
            .sink(receiveValue: { preview in
                print("on preview received: \(preview)")
                copy.preview = preview
                onComplete(copy)
            })
            .store(in: &previewCancellables)
    }
}

struct MessageViewSwift: View {
    @State private var store = MessageStore()
    @Binding var message: Message
    @Environment(\.user) var user
    
    var alignment: HorizontalAlignment {
        message.sender.id == user.id ? .trailing : .leading
    }
    
    var textAlignment: TextAlignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var frameAlignment: Alignment {
        return message.sender.id == user.id ? .trailing : .leading
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            HStack {
                VStack(alignment: alignment) {
                    Text(message.content)
                        .frame(maxWidth: .infinity, alignment: frameAlignment)
                    Text(message.sender.name).font(.caption2)
                        .frame(maxWidth: .infinity, alignment: frameAlignment)
                    if message.isSent {
                        Label("", systemImage: "checkmark")
                            .labelStyle(.iconOnly)
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                    }
                }
                .multilineTextAlignment(textAlignment)
            }
            if let preview = message.preview {
                AsyncImage(url: preview.image) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                    } else {
                        VStack {}
                    }
                }
            }
        }
        .onViewDidLoad {
            store.onMessageLoad(message) { message in
                self.message = message
            }
        }
    }
}

struct ProfileViewSwift: View {
    @Environment(\.user) var user
    
    var body: some View {
        Text("Profile de \(user.name)")
    }
}
