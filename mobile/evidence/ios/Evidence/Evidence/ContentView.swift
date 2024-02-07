import SwiftUI
import Chat
import Profile
import Leaf
import Models
import Login

struct ContentView: View {
    @Environment(\.leafTheme) private var theme
<<<<<<< Updated upstream
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var loginSettingViewModel = LoginSettingModel()

    var body: some View {
        LoginView(viewModel: loginViewModel, loginSettingViewModel: loginSettingViewModel)
        //                TabView() {
        //                    LoginFlowView()
        //                        .tabItem {
        //                            Image(systemName: "person.circle.fill")
        //                            Text("Home")
        //                        }
        //        
        //                    HomeView()
        //                        .tabItem {
        //                            Image(systemName: "house.fill")
        //                            Text("Home")
        //                        }
        //        
        //                    YouView()
        //                        .tabItem {
        //                            Image(systemName: "face.dashed")
        //                            Text("You")
        //                        }
        //                }
        //                .tint(theme.color.text.primary)
        //    }
=======
<<<<<<< Updated upstream
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
        .tint(theme.color.text.primary)
=======
    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        LoginView(viewModel: LoginViewModel())
//        NavigationStack {
//            TabView() {
//                HomeView()
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                        Text("Home")
//                    }
//
//                YouView()
//                    .tabItem {
//                        Image(systemName: "face.dashed")
//                        Text("You")
//                    }
//            }
//            .tint(theme.color.text.primary)
//        }
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    }
}

#Preview {
    LeafThemeView {
        ContentView()
    }
}

//struct HomeView: View {
//    var body: some View {
//        ChatView(
//            model: ChatViewModel(
//                state: ChatViewState(
//                    messages: [
//                        Message.vini("hi"),
//                        Message.vini("hello"),
//                        Message.vini("howAreYouDoing"),
//                        Message.mac(id: UUID(1)),
//                    ].map {
//                        MessageViewModel(
//                            state: MessageViewState(message: $0)
//                        )
//                    },
//                    highlightedMessageId: UUID(1)
//                )
//            )
//        )
//    }
//}

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

//struct LoginFlowView: View {
//    @StateObject var viewModel = LoginViewModel()
//    var body: some View {
//        LoginView(viewModel: viewModel, loginSettingViewModel: <#LoginSettingModel#>)
//    }
//}
