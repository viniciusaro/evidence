import SwiftUI

@Observable 
class HomeModel {
    var chatList: ChatListModel = .init()
    var profile: ProfileModel = .init()
    var selectedTab: Tab = .chatList
    
    public enum Tab: String, Codable {
        case chatList = "Conversas"
        case profile = "Perfil"
        
        var title: String {
            return rawValue.capitalized
        }
    }
}

extension HomeModel {
    func onNewChatButtonTapped() {
        chatList.newChatSetup = NewChatSetupModel()
    }
}

struct HomeViewMVVM: View {
    @Bindable var model: HomeModel
    
    var body: some View {
        NavigationStack {
            TabView(
                selection: $model.selectedTab
            ) {
                ChatListViewMVVM(model: model.chatList)
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.chatList.title,
                            systemImage: "bubble.right"
                        )
                    }
                    .tag(HomeFeature.State.Tab.chatList)
                    
                ProfileViewMVVM(model: model.profile)
                    .tabItem {
                        Label(
                            HomeFeature.State.Tab.profile.title,
                            systemImage: "brain.filled.head.profile"
                        )
                    }
                    .tag(HomeFeature.State.Tab.profile)
            }
            .navigationDestination(
                item: $model.chatList.detail
            ) { model in
                ChatDetailViewMVVM(model: model)
            }
            .sheet(
                item: $model.chatList.newChatSetup
            ) { model in
                NavigationView {
                    NewChatSetupViewMVVM(model: model)
                        .navigationTitle("Selecione os participantes")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationTitle(model.selectedTab.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    model.onNewChatButtonTapped()
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
