import SwiftUI
import Chat
import Profile
import Leaf
import Models
import Login

struct ContentView: View {
    @Environment(\.leafTheme) private var theme
    var body: some View {
        LoginTestView()
    }
}

#Preview {
    LeafThemeView {
        ContentView()
    }
}

struct HomeView: View {
    var body: some View {
        ChatView(
            model: ChatViewModel(
                state: ChatViewState(
                    messages: [
                        Message.vini("hi"),
                        Message.vini("hello"),
                        Message.vini("howAreYouDoing"),
                        Message.mac(id: UUID(1)),
                    ].map {
                        MessageViewModel(
                            state: MessageViewState(message: $0)
                        )
                    },
                    highlightedMessageId: UUID(1)
                )
            )
        )
    }
}

struct YouView: View {
    @StateObject var model = StatusViewModel()
    
    var body: some View {
        VStack {
            AvatarStatusView(model: model)
                .padding(.top, 20)
            StatusView(model: model)
            Spacer()
        }
    }
}

struct LoginTestView: View {
    @StateObject var model = LoginViewModel()
    var body: some View {
        LoginView(model: model)
    }
}
