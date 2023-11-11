import SwiftUI
import Chat
import Leaf
import Models

struct ContentView: View {
    var body: some View {
        ChatView(
            model: ChatViewModel(
                chat: Chat(
                    messages: [
                        Message.hi,
                        Message.hello,
                        Message.howAreYouDoing,
                        Message.mac,
                        Message.link,
                    ]
                )
            )
        )
    }
}

#Preview {
    LeafThemeView {
        ContentView()
    }
}
