import Combine
import SwiftUI

#Preview {
    ContentView()
}

let chatsUpdate = [
    Chat(
        name: "Lili ❤️‍🔥",
        messages: [
            Message(content: "Oi amor")
        ]
    ),
    Chat(
        name: "Grupo da Família",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Nossas Receitas",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Infinito particular",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
    Chat(
        name: "Snow dos brothers 2024",
        messages: [
            Message(content: "Bom dia!")
        ]
    ),
]

struct ContentView: View {
    var body: some View {
        ChatListView(
            store: Store(
                initialState: AppState(chats: []),
                reducer: Reducer { state, action in
                    switch action {
                    case .load:
                        state.chats = chatsUpdate
                    }
                }
            )
        )
    }
}

struct ChatListView: View {
    let store: Store<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        store.send(.load)
    }
    
    var body: some View {
        WithViewStore(store: store) { state in
            NavigationView {
                List {
                    ForEach(state.chats) { chat in
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.messages.first?.content ?? "").font(.caption)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Conversas")
            }
        }
    }
}

struct WithViewStore<State, Action>: View {
    @ObservedObject private var viewStore: ViewStore<State, Action>
    private let viewBuilder: (State) -> any View
    
    init(
        store: Store<State, Action>,
        @ViewBuilder viewBuilder: @escaping (State) -> any View
    ) {
        self.viewStore = ViewStore(store: store)
        self.viewBuilder = viewBuilder
    }
    
    var body: some View {
        AnyView(self.viewBuilder(self.viewStore.state))
    }
}

enum AppAction {
    case load
}

struct AppState {
    var chats: [Chat]
    var highlightedMessage: Message?
}

struct Chat: Identifiable {
    let id = UUID()
    let name: String
    let messages: [Message]
}

struct Message {
    let content: String
}

class ViewStore<State, Action>: ObservableObject {
    @Published var state: State
    private var storeSinkCancellable: AnyCancellable?
    
    init(store: Store<State, Action>) {
        self.state = store.state
        self.storeSinkCancellable = store.$state.sink { [weak self] update in
            self?.state = update
        }
    }
    
    deinit {
        self.storeSinkCancellable?.cancel()
    }
}

class Store<State, Action> {
    @Published fileprivate var state: State
    private let reducer: Reducer<State, Action>
    
    init(initialState: State, reducer: Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer.run(&state, action)
    }
}

struct Reducer<State, Action> {
    let run: (_ state: inout State, _ action: Action) -> Void
}
