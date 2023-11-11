import SwiftUI
import Models

public class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [MessageViewModel]
    
    public init(chat: Chat) {
        self.messages = chat.messages.map { MessageViewModel(message: $0) }
    }
}

public struct ChatView: View {
    @ObservedObject var model: ChatViewModel
    
    public init(model: ChatViewModel) {
        self.model = model
    }
    
    public var body: some View {
        List(self.model.messages.reversed()) { model in
            MessageView(model: model)
                .rotationEffect(.radians(.pi))
        }
        .rotationEffect(.radians(.pi))
        .listStyle(.plain)
    }
}

#Preview {
    ChatView(
        model: ChatViewModel(
            chat: Chat(
                messages: [
                    Message.hi,
                    Message.hello,
                    Message.howAreYouDoing,
                    Message.mac,
                    Message.tabNews,
                    Message.link,
                    Message.pr(3),
                ]
            )
        )
    )
}
