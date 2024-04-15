import Combine
import CasePaths
import SwiftUI

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State(),
            reducer: HomeFeature.reducer
        )
    )
}

struct HomeFeature: Feature {
    struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        var showAlert: Bool = false
        var alertText: String = ""
        
        enum Tab: String {
            case chatList = "Conversas"
            case profile = "Perfil"
            
            var title: String {
                return rawValue.capitalized
            }
        }
    }
    
    @CasePathable
    enum Action {
        case chatDetail(ChatDetailFeature.Action)
        case chatList(ChatListFeature.Action)
        case onNewChatAlertCancel
        case onNewChatAlertConfirm
        case onNewChatAlertTextChanged(String)
        case onNewChatButtonTapped
        case onNewChatShowAlertUpdate(Bool)
        case onTabSelectionChanged(State.Tab)
        case profile(ProfileFeature.Action)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .chatDetail:
                return .none
                
            case .chatList:
                return .none
            
            case .onNewChatAlertCancel:
                state.showAlert = false
                state.alertText = ""
                return .none
                
            case .onNewChatAlertConfirm:
                let chat = Chat(name: state.alertText, messages: [])
                state.chatList.chats.insert(chat, at: 0)
                state.chatList.detail = ChatDetailFeature.State(chat: chat)
                state.showAlert = false
                state.alertText = ""
                return .none
                
            case let .onNewChatAlertTextChanged(text):
                state.alertText = text
                return .none
                
            case .onNewChatButtonTapped:
                state.showAlert = true
                return .none

            case let .onNewChatShowAlertUpdate(showAlert):
                state.showAlert = showAlert
                return .none
                
            case let .onTabSelectionChanged(selection):
                state.selectedTab = selection
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
                .alert(
                    Text("Novo chat"),
                    isPresented: Binding(
                        get: { viewStore.showAlert },
                        set: { viewStore.send(.onNewChatShowAlertUpdate($0)) }
                    )
                ) {
                    Button("Cancelar", role: .cancel) {
                        viewStore.send(.onNewChatAlertCancel)
                    }
                    Button("OK") {
                        viewStore.send(.onNewChatAlertConfirm)
                    }
                    TextField("Nome", text: Binding(
                        get: { viewStore.alertText },
                        set: { viewStore.send(.onNewChatAlertTextChanged($0)) }
                    )).textContentType(.name)
                } message: {
                   Text("Escreva o nome do novo chat")
                }
                .navigationDestination(
                    item: Binding(
                        get: { viewStore.chatList.detail },
                        set: { viewStore.send(.chatList(.navigation($0)))}
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
                        viewStore.send(.onNewChatButtonTapped)
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
