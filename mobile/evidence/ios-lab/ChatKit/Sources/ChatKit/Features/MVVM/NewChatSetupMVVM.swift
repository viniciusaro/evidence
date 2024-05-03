import Dependencies
import SwiftUI

@Observable
class NewChatSetupModel: Identifiable {
    var chat: Chat
    var users: [User]
    var alertIsPresented: Bool
    var currentUser: User
    
    var id = UUID()
    var delegateOnNewChatSetup: (Chat) -> Void = { _ in fatalError() }
    
    init() {
        self.chat = .empty()
        self.users = [.vini, .lili, .cris]
        self.alertIsPresented = true
        self.currentUser = authClient.getAuthenticatedUser() ?? User()
    }
    
    func onUserSelected(_ user: User) {
        chat.participants = [currentUser, user]
        delegateOnNewChatSetup(chat)
    }
    
    func onAlertCancel() {
        Task {
            @Dependency(\.dismiss) var dismiss
            await dismiss()
        }
    }
    
    func onAlertConfirm() {
        alertIsPresented = false
    }
}

struct NewChatSetupViewMVVM: View {
    @Bindable var model: NewChatSetupModel
    
    var body: some View {
        List {
            ForEach(model.users) { user in
                Button {
                    model.onUserSelected(user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                        Text(user.id).font(.caption2)
                    }
                }
            }
        }
        .listStyle(.plain)
        .alert(
            Text("Novo chat"),
            isPresented: .constant(model.alertIsPresented)
        ) {
            Button("Cancelar", role: .cancel) {
                model.onAlertCancel()
            }
            Button("OK") {
                model.onAlertConfirm()
            }
            TextField("Nome", text: $model.chat.name)
                .textContentType(.name)
        } message: {
           Text("Escreva o nome do novo chat")
        }
    }
}
