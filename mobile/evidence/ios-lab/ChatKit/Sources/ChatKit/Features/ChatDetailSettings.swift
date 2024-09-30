import ComposableArchitecture
import Models
import SwiftUI

#Preview {
    NavigationStack {
        ChatDetailsSettingsView(store: Store(initialState: .init(chat: Shared(Chat.lili))) {
            ChatDetailSettingsFeature()
        })
    }
}

@Reducer
public struct ChatDetailSettingsFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared var chat: Chat
    }
    
    public enum Action {
        case onPluginToggle(Bool, Plugin)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onPluginToggle(bool, plugin):
                if bool == true {
                    state.chat.plugins.append(plugin)
                } else {
                    state.chat.plugins.remove(plugin)
                }
                return .none
            }
        }
    }
}

struct ChatDetailsSettingsView: View {
    @Bindable var store: StoreOf<ChatDetailSettingsFeature>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Name") {
                Text(store.chat.name)
            }
            Section("Participants") {
                List(store.chat.participants) { participant in
                    Text(participant.name)
                }
            }
            Section("Plugins") {
                List(Plugin.values) { plugin in
                    Toggle(isOn: Binding(
                        get: { store.chat.plugins.contains(plugin) },
                        set: { bool in store.send(.onPluginToggle(bool, plugin)) }
                    )
                    , label: {
                        Text(plugin.name)
                    })
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

