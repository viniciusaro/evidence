import Combine
import IdentifiedCollections
import SwiftUI

@Observable class ChatListModel {
    var chats: IdentifiedArrayOf<Chat> { didSet { saveChatOnChange() } }
    var detail: ChatDetailModel? = nil { didSet { bindDelegateOnDetailChange() } }
    var newChatSetup: NewChatSetupModel? = nil { didSet { bindDelegateOnNewChatSetupChange() } }

    private var cancellables: Set<AnyCancellable> = []
    
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
}

extension ChatListModel {
    func onListItemDelete(_ indexSet: IndexSet) {
        chats.remove(atOffsets: indexSet)
    }

    func onListItemTapped(_ chat: Chat) {
        detail = ChatDetailModel(chat: chat)
    }
    
    func onViewDidLoad() {
        stockClient.consume()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.onNewMessageReceived($0, $0.messages.first!) }
            .store(in: &cancellables)
    }
    
    private func onNewMessageReceived(_ chat: Chat, _ message: Message) {
        guard var existingChat = chats[id: chat.id] else {
            chats.insert(chat, at: 0)
            return
        }
        
        if let detail = detail, detail.chat.id == chat.id {
            detail.chat.messages.append(message)
            detail.messages.append(MessageModel(message: message))
        }
        
        chats[id: chat.id]?.messages.append(message)
    }
    
    private func saveChatOnChange() {
        if let data = try? JSONEncoder().encode(chats) {
            try? dataClient.save(data, .chats)
        }
    }
    
    private func bindDelegateOnDetailChange() {
        detail?.delegateOnChatUpdate = { [weak self] chatUpdate in
            self?.chats[id: chatUpdate.id] = chatUpdate
        }
    }
    
    private func bindDelegateOnNewChatSetupChange() {
        newChatSetup?.delegateOnNewChatSetup = { [weak self] chat in
            guard let self else { return }
            self.newChatSetup = nil
            self.chats.insert(chat, at: 0)
            self.detail = ChatDetailModel(chat: chat)
        }
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
