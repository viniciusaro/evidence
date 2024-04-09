import SwiftUI

@main
struct EvidenceLabApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootFeature.State(),
                    reducer: RootFeature.reducer
                )
            )
        }
    }
}
