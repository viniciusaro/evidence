import AuthClient
import ComposableArchitecture
import Models
import SwiftUI

#Preview {
    HomeView(store: Store(initialState: .init()) {
        HomeFeature()
    })
}

@Reducer
public struct HomeFeature {
    @Dependency(\.authClient) static var authClient
    
    @ObservableState
    public struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        var user: User
        
        var title: String {
            switch selectedTab {
            case .chatList:
                return selectedTab.rawValue + " - \(user.name)"
            case .profile:
                return selectedTab.rawValue
            }
        }
        
        init() {
            self.user = authClient.getAuthenticatedUser() ?? User()
        }
        
        public enum Tab: String, Codable {
            case chatList = "Conversas"
            case profile = "Perfil"
        }
    }
    
    public enum Action: BindableAction {
        case onNewChatButtonTapped
        case binding(BindingAction<State>)
        case chatList(ChatListFeature.Action)
        case profile(ProfileFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onNewChatButtonTapped:
                state.chatList.newChatSetup = NewChatSetupFeature.State()
                return .none

            case .binding:
                return .none
                
            case .chatList:
                return .none
                
            case .profile:
                return .none
            }
        }
        Scope(state: \.chatList, action: \.chatList) {
            ChatListFeature()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        BindingReducer()
    }
}

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        NavigationStack {
            TabView(
                selection: $store.selectedTab
            ) {
                ChatListView(store: store.scope(state: \.chatList, action: \.chatList))
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.chatList.rawValue,
                            systemImage: "bubble.right"
                        )
                    }
                    .tag(HomeFeature.State.Tab.chatList)
                
                ProfileView(store: store.scope(state: \.profile, action: \.profile))
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.profile.rawValue,
                            systemImage: "brain.filled.head.profile"
                        )
                    }
                    .tag(HomeFeature.State.Tab.profile)
            }
            .navigationDestination(item: $store.scope(
                state: \.chatList.detail,
                action: \.chatList.detail
            )) { store in
                ChatDetailView(store: store)
            }
            .sheet(item: $store.scope(
                state: \.chatList.newChatSetup,
                action: \.chatList.newChatSetup
            )) { store in
                NavigationView {
                    NewChatSetupView(store: store)
                        .navigationTitle("Selecione os participantes")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationTitle(store.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    store.send(.onNewChatButtonTapped)
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(.primary)
                })
            }
        }
    }
}
