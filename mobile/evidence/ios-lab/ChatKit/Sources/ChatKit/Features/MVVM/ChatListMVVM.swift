import Combine
import IdentifiedCollections
import SwiftUI

@Observable
class ChatListModel {
    var chats: IdentifiedArrayOf<Chat>
    var detail: ChatDetailModel? = nil
    
    private var consumeCancellable: AnyCancellable? = nil
    
    init() {
        do {
            self.chats = try JSONDecoder().decode(
                IdentifiedArrayOf<Chat>.self,
                from: dataClient.load(.chats)
            )
        } catch {
            self.chats = []
        }
    }
    
    func onListItemTapped(_ chat: Chat) {
        
    }
    
    func onListItemDelete(_ indextSet: IndexSet) {
        
    }
    
    func onViewDidLoad() {
        consumeCancellable?.cancel()
        consumeCancellable = stockClient.consume()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.onNewMessageReceived($0, $0.messages.first!) }
    }
    
    private func onNewMessageReceived(_ chat: Chat, _ message: Message) {
        guard var existingChat = chats[id: chat.id] else {
            chats.insert(chat, at: 0)
            return
        }
        chats[id: chat.id]?.messages.append(message)
    }
}

struct ChatListViewMVVM: View {
    let model: ChatListModel
    
    var body: some View {
        List {
            ForEach(model.chats) { chat in
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
                model.onListItemDelete(indexSet)
            }
        }
        .animation(.bouncy, value: model.chats)
        .listStyle(.plain)
        .onViewDidLoad {
            model.onViewDidLoad()
        }
    }
}
