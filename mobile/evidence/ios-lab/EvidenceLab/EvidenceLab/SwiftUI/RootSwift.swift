import Combine
import IdentifiedCollections
import SwiftUI

#Preview("ChatList") {
    authClient = AuthClient.authenticated()
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.mock(Chat.mockList, interval: 10000)
    installationClient = InstallationClient.mock("1")

    return ChatApp()
}

struct ChatApp: View {
    @Bindable var store = ChatStore()
    
    var body: some View {
        ChatListViewSwift(chats: $store.chats)
    }
}

@Observable
class ChatStore {
    var chats: [Chat] = []
    private var cancellable: AnyCancellable?
    
    init() {
        do {
            let data = try dataClient.load(.chats)
            let decoder = JSONDecoder()
            self.chats = try decoder.decode([Chat].self, from: data)
        } catch {
            self.chats = []
        }
        
        self.consumePendingMessages()
    }
    
    private func consumePendingMessages() {
        self.cancellable = stockClient.consume()
            .sink(receiveValue: { chatUpdate in
                if let index = self.chats.firstIndex(where: { $0.id == chatUpdate.id }) {
                    self.chats[index].messages.append(contentsOf: chatUpdate.messages)
                } else {
                    self.chats.insert(chatUpdate, at: 0)
                }
            })
    }
}

struct ChatListViewSwift: View {
    @Binding var chats: [Chat]
    @State private var detail: Chat.ID? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($chats) { $chat in
                    Button {
                        self.detail = chat.id
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
            .animation(.bouncy, value: chats)
            .listStyle(.plain)
            .navigationDestination(item: $detail) { id in
                let index = chats.firstIndex(where: { $0.id == id })!
                return ChatDetailViewSwift(chat: $chats[index])
            }
        }
    }
}

struct ChatDetailViewSwift: View {
    @Binding var chat: Chat
    @State var inputText: String = ""

    var body: some View {
        VStack {
            List {
                ForEach(chat.messages) { message in
                    Text(message.content)
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
