import ComposableArchitecture
import Models
import SwiftUI

@Reducer
public struct PluginsListFeature {
    @ObservableState
    public struct State: Equatable {
        var plugins: IdentifiedArrayOf<Plugin> = [
            .openAI, 
            .ping,
            .chaves
        ]
    }
    
    public enum Action {
        
    }
}

struct PluginsListView: View {
    let store: StoreOf<PluginsListFeature>
    
    var body: some View {
        List(store.plugins) { plugin in
            HStack {
                
            }
        }
    }
}
