import SwiftUI
import Chat
import Profile
import Leaf
import Models

struct ContentView: View {
    var body: some View {
            TabView() {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    
                YouView()
                    .tabItem {
                        Image(systemName: "face.dashed")
                        Text("You")
                    }
            }
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

struct YouView: View {
    var body: some View {
//        AvatarStatusView(model: StatusViewModel())
        Text("It's coming!")
    }
}
