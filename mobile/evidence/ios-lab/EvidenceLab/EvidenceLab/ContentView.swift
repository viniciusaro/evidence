import Combine
import ComposableArchitecture
import SwiftUI

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}

