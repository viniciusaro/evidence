import Combine
import ComposableArchitecture
import SwiftUI

#Preview {
    dataClient = DataClient.mock(Chat.mockList)
    
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
    struct State: Equatable {
        var chatList: ChatListFeature.State = .init()
        var profile: ProfileFeature.State = .init()
        var selectedTab: Tab = .chatList
        var showAlert: Bool = false
        var alertText: String = ""
        
        @CasePathable
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
        case chatList(ChatListFeature.Action)
        case onNewChatAlertCancel
        case onNewChatAlertConfirm
        case onNewChatAlertTextChanged(String)
        case onNewChatButtonTapped
        case onNewChatShowAlertUpdate(Bool)
        case onTabSelectionChanged(State.Tab)
        case profile(ProfileFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
            .alert(
                Text("Novo chat"),
                isPresented: Binding(
                    get: { store.showAlert },
                    set: { store.send(.onNewChatShowAlertUpdate($0)) }
                )
            ) {
                Button("Cancelar", role: .cancel) {
                    store.send(.onNewChatAlertCancel)
                }
                Button("OK") {
                    store.send(.onNewChatAlertConfirm)
                }
                TextField("Nome", text: Binding(
                    get: { store.alertText },
                    set: { store.send(.onNewChatAlertTextChanged($0)) }
                )).textContentType(.name)
            } message: {
               Text("Escreva o nome do novo chat")
            }
            .navigationDestination(item: $store.scope(
                state: \.chatList.detail,
                action: \.chatList.detail
            )) { store in
                ChatDetailView(store: store)
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
