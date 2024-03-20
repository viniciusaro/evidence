import SwiftUI
import Chat
import Profile
import Leaf
import Models
import Login

struct ContentView: View {
    @Environment(\.leafTheme) private var theme
    @ObservedObject var loginViewModel = LoginViewModel()

    var body: some View {
        ZStack {
            NavigationStack {
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

                    LoginSettingView(viewModel: LoginSettingViewModel())
                        .tabItem {
                            Image(systemName: "gearshape.circle.fill")
                            Text("Setting")
                        }
                }
                .tint(theme.color.text.primary)
            }
        }
        .onAppear {
            loginViewModel.getAuthenticationUser()
        }
        .fullScreenCover(isPresented: $loginViewModel.isUserAuthenticated, content: {
           LoginView(viewModel: loginViewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.color.backgrond.aubergine)
        })
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

