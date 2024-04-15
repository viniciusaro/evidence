import Combine
import ComposableArchitecture
import SwiftUI

#if DEBUG
var authClient = AuthClient.live
var dataClient = DataClient.live
#else
let authClient = AuthClient.live
let dataClient = DataClient.live
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
    struct State: Equatable {
        var home: HomeFeature.State = .init()
        @Presents var login: LoginFeature.State? = nil
    }
    
    @CasePathable
    enum Action {
        case home(HomeFeature.Action)
        case login(PresentationAction<LoginFeature.Action>)
        case viewDidLoad
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer().ifLet(\.$login, action: \.login) {
            LoginFeature()
        }
        Reduce { state, action in
            switch action {
            case .home:
                return .none
                
            case .login(.presented(.onUserAuthenticated)):
                state.login = nil
                return .none
                
            case .login:
                return .none
                
            case .viewDidLoad:
                let user = authClient.getAuthenticatedUser()
                state.login = user == nil ? LoginFeature.State() : nil
                return .none
            }
        }
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home(.chatList(.detail(.presented(.send)))):
                guard let lastIndex = state.home.chatList.detail?.messages.count else {
                    return .none
                }
                
                state.home.chatList.detail?.messages[lastIndex - 1].message.isSent = true
                state.home.chatList.detail?.chat.messages[lastIndex - 1].isSent = true
                
                var chats = state.home.chatList.chats
                let detailState = state.home.chatList.detail
                
                if let detailState = detailState {
                    chats[id: detailState.chat.id] = detailState.chat
                }
                
                return .run { [chats = chats] _ in
                    let data = try JSONEncoder().encode(chats)
                    try dataClient.save(data, .chats)
                }
            default:
                return .none
            }
        }
    }
}

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        HomeView(
            store: store.scope(state: \.home, action: \.home)
        )
        .onViewDidLoad {
            store.send(.viewDidLoad)
        }
        .sheet(item: $store.scope(state: \.login, action: \.login)) { store in
            LoginView(store: store)
        }
    }
}

