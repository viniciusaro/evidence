import Combine
import CasePaths
import SwiftUI

struct HomeFeature: Feature {
    struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        
        enum Tab: String {
            case chatList = "Conversas"
            case profile = "Perfil"
            
            var title: String {
                return rawValue.capitalized
            }
        }
        
        func chatIndex(id: ChatID) -> Int {
            chatList.chats.firstIndex(where: { $0.id == id })!
        }
    }
    
    @CasePathable
    enum Action {
        case onTabSelectionChanged(State.Tab)
        case chatList(ChatListFeature.Action)
        case chatDetail(ChatDetailFeature.Action)
        case newChatItemTapped
        case newChatCreated(Chat)
        case profile(ProfileFeature.Action)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .onTabSelectionChanged(selection):
                state.selectedTab = selection
                return .none
            
            case .chatList:
                return .none
            
            case .chatDetail:
                return .none
            
            case .newChatItemTapped:
                return .publisher(
                    chatClient.new("Lili")
                        .map { .newChatCreated($0) }
                )
            
            case let .newChatCreated(chat):
                return .none
                
            case .profile:
                return .none
            }
        },
        .scope(state: \.chatList, action: \.chatList) {
            ChatListFeature.reducer
        },
        .ifLet(state: \.chatList.detail, action: \.chatDetail) {
            ChatDetailFeature.reducer
        },
        .scope(state: \.profile, action: \.profile) {
            ProfileFeature.reducer
        }
    )
}

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            NavigationStack {
                TabView(
                    selection: Binding(
                        get: { viewStore.selectedTab },
                        set: { viewStore.send(.onTabSelectionChanged($0)) }
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
                .navigationDestination(
                    item: Binding(
                        get: { viewStore.chatList.detail },
                        set: { viewStore.send(.chatList(.chatListNavigation($0)))}
                    )
                ) { chatDetail in
                    ChatDetailView(
                        store: store.scope(state: { _ in chatDetail }, action: \.chatDetail)
                    )
                }
                .navigationTitle(viewStore.selectedTab.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(action: {
                        viewStore.send(.newChatItemTapped)
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
}
