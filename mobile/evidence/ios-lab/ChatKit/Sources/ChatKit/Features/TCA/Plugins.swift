import ComposableArchitecture
import Models
import SwiftUI

@Reducer
public struct PluginsFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action {
        
    }
}

struct PluginsView: View {
    let store: StoreOf<PluginsFeature>
    
    var body: some View {
        EmptyView()
    }
}
