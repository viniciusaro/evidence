import Combine
import ComposableArchitecture
import SwiftUI

#Preview {
    authClient = AuthClient.authenticated()
    dataClient = DataClient.mock(Chat.mockList)
    stockClient = StockClient.mock(Chat.mockList, interval: 20)
    
    return HomeView(
        store: Store(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
    )
}

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable, Codable {
        var chatList: ChatListFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        
        @CasePathable
        enum Tab: String, Codable {
            case chatList = "Conversas"
            case profile = "Perfil"
            
            var title: String {
                return rawValue.capitalized
            }
        }
    }
    @CasePathable
    enum Action {
        case chatList(ChatListFeature.Action)
        case profile(ProfileFeature.Action)
        case onNewChatButtonTapped
        case onTabSelectionChanged(State.Tab)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .chatList(.newChatSetup(.presented(.delegate(.onNewChatSetup(chat))))):
                state.chatList.newChatSetup = nil
                state.chatList.chats.insert(chat, at: 0)
                guard let shared = state.chatList.$chats[id: chat.id] else {
                    return .none
                }
                state.chatList.newChatSetup = nil
                state.chatList.detail = ChatDetailFeature.State(chat: shared)
                return .none

            case .chatList:
                return .none
                
            case .onNewChatButtonTapped:
                state.chatList.newChatSetup = NewChatSetupFeature.State()
                return .none
                
            case let .onTabSelectionChanged(selection):
                state.selectedTab = selection
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
    }
}

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        NavigationStack {
            TabView(
                selection: Binding(
                    get: { store.selectedTab },
                    set: { store.send(.onTabSelectionChanged($0)) }
                )
            ) {
                ChatListView(store: store.scope(state: \.chatList, action: \.chatList))
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.chatList.title,
                            systemImage: "bubble.right"
                        )
                    }
                    .tag(HomeFeature.State.Tab.chatList)
                    
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
