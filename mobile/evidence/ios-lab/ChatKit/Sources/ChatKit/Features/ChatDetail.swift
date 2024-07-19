import AuthClient
import ComposableArchitecture
import Leaf
import Models
import StockClient
import SwiftUI

#Preview {
    LeafThemeView {
        NavigationStack {
            ChatDetailView(store: Store(
                initialState: .init(
                    chat: Shared(.evidence),
                    inputText: "/",
                    commandSelectionList: Plugin.openAI.commands
                )
            ) {
                ChatDetailFeature()
            })
        }
    }
}

@Reducer
public struct ChatDetailFeature {
    @Dependency(\.authClient) static var authClient
    @Dependency(\.stockClient) var stockClient
    @Dependency(\.previewClient) var previewClient
    
    @ObservableState
    public struct State: Equatable {
        @Shared var chat: Chat
        var user: User
        var inputText: String = ""
        var inputFocused: Bool = false
        var commandSelectionList: [Plugin.Command]? = nil
        @Presents var settings: ChatDetailSettingsFeature.State? = nil

        init(
            chat: Shared<Chat>,
            inputText: String = "",
            commandSelectionList: [Plugin.Command]? = nil,
            settings: ChatDetailSettingsFeature.State? = nil
        ) {
            self._chat = chat
            self.user = authClient.getAuthenticatedUser() ?? User()
            self.inputText = inputText
            self.commandSelectionList = commandSelectionList
            self.settings = settings
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onCommandSelectionListItemTapped(Plugin.Command)
        case onMessageSentConfirmation(Message)
        case onMessageViewDidLoad(Message)
        case onMessagePreviewDidLoad(Message, Models.Preview)
        case onTextFieldValueChanged(String)
        case onSettingsButtonTapped
        case send
        case settings(PresentationAction<ChatDetailSettingsFeature.Action>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .onCommandSelectionListItemTapped(command):
                state.inputText = "/\(command.name) "
                state.commandSelectionList = nil
                return .none
                
            case let .onMessageViewDidLoad(message):
                guard
                    let url = URL(string: message.content),
                    url.host() != nil,
                    message.preview == nil else {
                    return .none
                }
                
                return .publisher {
                    previewClient.get(url)
                        .receive(on: DispatchQueue.main)
                        .filter { $0 != nil }
                        .map { $0! }
                        .map { Preview(image: $0.image, title: $0.title) }
                        .map { .onMessagePreviewDidLoad(message, $0) }
                }
                
            case let .onMessagePreviewDidLoad(message, preview):
                state.chat.messages[id: message.id]?.preview = preview
                return .none
                
            case .onMessageSentConfirmation:
                return .none
                
            case let .onTextFieldValueChanged(text):
                state.inputText = text
                if text.starts(with: "/") && !text.contains(" ") {
                    let cleanedUpText = text
                        .replacingOccurrences(of: "/", with: "")
                    
                    state.commandSelectionList = state.chat.plugins
                        .flatMap { $0.commands }
                        .filter {
                            cleanedUpText.isEmpty || $0.name.contains(cleanedUpText)
                        }
                } else {
                    state.commandSelectionList = nil
                }
                return .none
                
            case .onSettingsButtonTapped:
                state.settings = ChatDetailSettingsFeature.State(chat: state.$chat)
                return .none
                
            case .send:
                state.inputText = ""
                state.commandSelectionList = nil
                return .none
            
            case .settings(.presented(.onPluginToggle(_, _))):
                guard state.commandSelectionList != nil else {
                    return .none
                }
                
                let cleanedUpText = state.inputText
                    .replacingOccurrences(of: "/", with: "")
                
                state.commandSelectionList = state.chat.plugins
                    .flatMap { $0.commands }
                    .filter { cleanedUpText.isEmpty || $0.name.contains(cleanedUpText) }
                return .none
                
            case .settings:
                return .none
            }
        }
        .ifLet(\.$settings, action: \.settings) {
            ChatDetailSettingsFeature()
        }
        BindingReducer()
    }
}

struct ChatDetailView: View {
    @Environment(\.leafTheme) var theme
    @Bindable var store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List {
                    ForEach($store.chat.messages) { $message in
                        MessageView(user: store.user, message: $message)
                            .onViewDidLoad {
                                store.send(.onMessageViewDidLoad(message))
                            }
                            .id(message.id)
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: store.chat.messages) { _, messages in
                    if let id = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(id)
                        }
                    }
                }
                .onChange(of: store.inputFocused) { _, focused in
                    if let id = store.chat.messages.last?.id, focused == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(id)
                            }
                        }
                    }
                }
                .onViewDidLoad {
                    if let id = store.chat.messages.last?.id {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo(id)
                            }
                        }
                    }
                }
            }
            InputView(store: store)
                .padding([.bottom], 6)
                .padding([.leading, .trailing], 12)
                .background(theme.color.backgrond.container)
        }
        .listStyle(.plain)
        .navigationTitle(store.chat.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                store.send(.onSettingsButtonTapped)
            }, label: {
                Label("", systemImage: "gearshape")
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .foregroundStyle(theme.color.text.primary, .primary)
            })
        }
        .sheet(item: $store.scope(
            state: \.settings,
            action: \.settings
        )) { store in
            NavigationStack {
                ChatDetailsSettingsView(store: store)
            }
        }
    }
}

private struct InputView: View {
    @Environment(\.leafTheme) var theme
    @FocusState var focus
    @Bindable var store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack(spacing: 6) {
            LazyVStack {
                if store.commandSelectionList?.isEmpty == false {
                    Spacer().frame(height: 8)
                }
                ForEach(store.commandSelectionList ?? []) { command in
                    Button(action: {
                        store.send(.onCommandSelectionListItemTapped(command))
                    }, label: {
                        VStack(alignment: .leading) {
                            Text("/\(command.name)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(command.description)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
                            Divider()
                        }
                    })
                }
            }
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(theme.color.text.primary, .primary)
                })
                TextField(
                    "", 
                    text: Binding(
                        get: { store.inputText },
                        set: { store.send(.onTextFieldValueChanged($0)) }
                    ),
                    axis: .vertical
                )
                .frame(minHeight: 36)
                .focused($focus)
                .lineLimit(5)
                .padding([.leading, .trailing], 10)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(theme.color.backgrond.background)
                )
                Button(action: {
                    store.send(.send)
                }, label: {
                    Label("", systemImage: "arrow.forward.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundStyle(theme.color.text.primaryOnBackground, .primary)
                })
            }
        }
        .bind($focus, to: $store.inputFocused)
    }
}
