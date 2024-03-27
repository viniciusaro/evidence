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
        NavigationStack {
            ChatListView(
                store: Store(
                    initialState: AppState(),
                    reducer: Reducer { state, action in
                        switch action {
                        case .load:
                            state.chats = chatsUpdate
                        case let .chatDetail(id: id):
                            state.chatDetail = state.chats.first(where: { $0.id == id })
                        }
                    }
                    .debug(before: false)
                )
            )
        }
    }
}

struct ChatListView: View {
    let store: Store<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        store.send(.load)
    }
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.chats) { chat in
                    Button(action: {
                        viewStore.send(.chatDetail(id: chat.id))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.messages.first?.content ?? "").font(.caption)
                        }
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Conversas")
            .navigationDestination(
                item: Binding(
                    get: { viewStore.chatDetail },
                    set: { chat in viewStore.send(.chatDetail(id: chat?.id))}
                )) { chat in
                    ChatView(id: chat.id, store: store)
                }
        }
    }
}

struct ChatView: View {
    let id: UUID
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            List {
                ForEach(viewStore.state.chat(id).messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.content)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(viewStore.state.chat(id).name)
        }
    }
}

struct WithViewStore<State, Action>: View {
    @ObservedObject private var viewStore: ViewStore<State, Action>
    private let viewBuilder: (ViewStore<State, Action>) -> any View
    
    init(
        store: Store<State, Action>,
        @ViewBuilder viewBuilder: @escaping (ViewStore<State, Action>) -> any View
    ) {
        self.viewStore = ViewStore(store: store)
        self.viewBuilder = viewBuilder
    }
    
    var body: some View {
        AnyView(self.viewBuilder(self.viewStore))
    }
}

enum AppAction {
    case load
    case chatDetail(id: UUID?)
}

struct AppState {
    var chats: [Chat] = []
    var chatDetail: Chat?
    
    func chat(_ id: UUID) -> Chat {
        chats.first(where: { $0.id == id })!
    }
}

struct Chat: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let messages: [Message]
}

struct Message: Identifiable, Equatable, Hashable {
    let id = UUID()
    let content: String
}

@dynamicMemberLookup
class ViewStore<State, Action>: ObservableObject {
    @Published var state: State
    private var storeSinkCancellable: AnyCancellable?
    private(set) var send: (Action) -> Void
    
    init(store: Store<State, Action>) {
        self.state = store.state
        self.send = store.send
        self.storeSinkCancellable = store.$state.sink { [weak self] update in
            self?.state = update
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        return state[keyPath: keyPath]
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

extension Reducer {
    func debug(before: Bool = true, after: Bool = true) -> Reducer<State, Action> {
        return Reducer { state, action in
            print("receiving \(action)")
            if before {
                var before = String()
                dump(state, to: &before)
                print("before: \(before)")
            }
            self.run(&state, action)
            if after {
                print("------")
                var after = String()
                dump(state, to: &after)
                print("after: \(after)")
            }
        }
    }
}
