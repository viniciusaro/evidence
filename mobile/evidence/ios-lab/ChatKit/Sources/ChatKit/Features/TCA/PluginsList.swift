import ComposableArchitecture
import Models
import SwiftUI

@Reducer
public struct PluginsListFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action {
        
    }
}

struct PluginsListView: View {
    let store: StoreOf<PluginsListFeature>
    
    var body: some View {
        Text("Plugins")
    }
}
