import Chat
import CasePaths
import Profile
import Leaf
import Models
import SwiftUI

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
            store: Store(
                state: ChatFeature.State(
                    messages: [
                        Message.vini("hi"),
                        Message.vini("hello"),
                        Message.vini("howAreYouDoing"),
                        Message.mac(id: UUID(1)),
                    ].map {
                        .init(message: $0)
                    },
                    highlightedMessageId: UUID(1)
                ),
                reducer: combine(
                    ChatFeature.reducer,
                    forEach(
                        MessageFeature.reducer,
                        state: \.messages,
                        action: AnyCasePath(\ChatFeature.Action.Cases.message)
                    )
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
