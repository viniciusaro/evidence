import Combine
import ComposableArchitecture
import SwiftUI

@Observable 
class ChatDetailModel {
    var chat: Chat { didSet { delegateOnChatUpdate(chat) } }
    var inputText: String
    var messages: [MessageModel]
    
    var delegateOnChatUpdate: (Chat) -> Void = { _ in fatalError() }
    private var cancellables: Set<AnyCancellable> = []
    
    init(chat: Chat, inputText: String = "") {
        self.chat = chat
        self.inputText = inputText
        self.messages = chat.messages.map { MessageModel(message: $0) }
    }
}

extension ChatDetailModel {
    func send() {
        let user = authClient.getAuthenticatedUser() ?? User()
        let newMessage = Message(content: inputText, sender: user)
        let newMessageModel = MessageModel(message: newMessage)
        chat.messages.append(newMessage)
        messages.append(newMessageModel)
        inputText = ""
        
        let chatUpdate = ChatUpdate(
            chatId: chat.id,
            name: chat.name,
            message: newMessage,
            participants: chat.participants
        )
        
        stockClient.send(chatUpdate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.onMessageSentConfirmation(newMessage) }
            .store(in: &cancellables)
    }
    
    private func onMessageSentConfirmation(_ message: Message) {
        //
    }
}

struct ChatDetailViewMVVM: View {
    @Bindable var model: ChatDetailModel
    
    var body: some View {
        VStack {
            List {
                ForEach(model.messages) { model in
                    MessageViewMVVM(model: model)
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
                TextField("", text: $model.inputText)
                .frame(height: 36)
                .padding([.leading, .trailing], 8)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                )
                Button(action: {
                    model.send()
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
        .navigationTitle(model.chat.name)
    }
}
