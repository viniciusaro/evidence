import Combine
import CasePaths
import SwiftUI

let authClient = AuthClient.authenticated()
let chatClient = ChatClient.filesystem
let chatDocumentClient = AnyDocumentClient<Chat>.file("chats")

#Preview {
    RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: RootFeature.reducer
        )
    )
}

