import Combine
import ComposableArchitecture
import SwiftUI

#if DEBUG
var authClient = AuthClient.authenticated(.vini)
var dataClient = DataClient.live
var stockClient = StockClient.live
var installationClient = InstallationClient.mock("1")
#else
let authClient = AuthClient.live
let dataClient = DataClient.live
let stockClient = StockClient.live
let installationClient = InstallationClient.mock("1")
#endif

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    
    return RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: { RootFeature() }
        )
    )
}

@Reducer
struct RootFeature {
    @ObservableState
    enum State {
        case home(HomeFeature.State)
        case login(LoginFeature.State)
        
        init() {
            if let _ = authClient.getAuthenticatedUser() {
                self = .home(HomeFeature.State())
            } else {
                self = .login(LoginFeature.State())
            }
        }
    }
    
    @CasePathable
    enum Action {
        case home(HomeFeature.Action)
        case login(LoginFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
        .ifLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifLet(\.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home:
                return .none

            case .login(.onUserAuthenticated):
                state = .home(HomeFeature.State())
                return .none

            case .login:
                return .none
            }
        }
        Reduce { state, action in
            guard case var .home(homeState) = state else {
                return .none
            }
            
            if let lastIndex = homeState.chatList.detail?.messages.count {
                homeState.chatList.detail?.messages[lastIndex - 1].message.isSent = true
//                homeState.chatList.detail?.chat.messages[lastIndex - 1].isSent = true
            }
            
            state = .home(homeState)
            var chats = homeState.chatList.chats
            let detailState = homeState.chatList.detail
            
            if let detailState = detailState {
                chats[id: detailState.chat.id] = detailState.chat
            }
            
            return .run { [chats = chats] _ in
                let data = try JSONEncoder().encode(chats)
                try dataClient.save(data, .chats)
            }
        }
    }
}

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        VStack {
            if let homeStore = store.scope(state: \.home, action: \.home) {
                HomeView(store: homeStore)
            } else if let loginStore = store.scope(state: \.login, action: \.login) {
                LoginView(store: loginStore)
            } else {
                fatalError("Invalid Root State")
            }
        }
    }
}

