import ComposableArchitecture
import SwiftUI

#Preview {
    HomeView(store: Store(initialState: .init()) {
        HomeFeature()
    })
}

@Reducer
public struct HomeFeature {
    @ObservableState 
    public struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var plugins: PluginsFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        
        public enum Tab: String, Codable {
            case chatList = "Conversas"
            case plugins = "Plugins"
            case profile = "Perfil"
            
            var title: String {
                return rawValue.capitalized
            }
        }
    }
    
    public enum Action: BindableAction {
        case onNewChatButtonTapped
        case binding(BindingAction<State>)
        case chatList(ChatListFeature.Action)
        case plugins(PluginsFeature.Action)
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
                
            case .plugins:
                return .none
                
            case .profile:
                return .none
            }
        }
        Scope(state: \.chatList, action: \.chatList) {
            ChatListFeature()
        }
        Scope(state: \.plugins, action: \.plugins) {
            PluginsFeature()
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
                            HomeFeature.State.Tab.chatList.title,
                            systemImage: "bubble.right"
                        )
                    }
                    .tag(HomeFeature.State.Tab.chatList)
                
                PluginsView(store: store.scope(state: \.plugins, action: \.plugins))
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.plugins.title,
                            systemImage: "brain.filled.head.profile"
                        )
                    }
                    .tag(HomeFeature.State.Tab.plugins)
                    
                ProfileView(store: store.scope(state: \.profile, action: \.profile))
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.profile.title,
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
            .navigationTitle(store.selectedTab.title)
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
