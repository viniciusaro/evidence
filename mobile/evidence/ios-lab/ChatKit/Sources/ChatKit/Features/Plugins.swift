import Combine
import ComposableArchitecture
import Foundation
import Models
import OpenAIClient

public enum PluginAction {
    case onMessageSent(ChatUpdate)
    case onMessageReceived(ChatUpdate)
    case send(ChatUpdate)
}

struct PluginsMapperReducer<State, Action>: Reducer {
    let state: WritableKeyPath<State, IdentifiedArrayOf<Chat>>
    let action: CaseKeyPath<Action, PluginAction>
    let child: () -> any Reducer<Chat, PluginAction>
    
    init(
        _ state: WritableKeyPath<State, IdentifiedArrayOf<Chat>>,
         action: CaseKeyPath<Action, PluginAction>,
         child: @escaping () -> any Reducer<Chat, PluginAction>
    ) {
        self.state = state
        self.action = action
        self.child = child
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            if let childAction = AnyCasePath(self.action).extract(from: action) {
                let chats = state[keyPath: self.state]
                var effects = [Effect<Action>]()
                for var chat in chats {
                    let effect = child().reduce(into: &chat, action: childAction)
                    state[keyPath: self.state][id: chat.id] = chat
                    
                    let parentEffect = effect.map { pluginAction in
                        AnyCasePath(self.action).embed(pluginAction)
                    }
                    effects.append(parentEffect)
                }
                return .merge(effects)
            }
            return .none
        }
    }
}

@Reducer
struct PluginMapper {
    private func reducer(for plugin: Plugin) -> any Reducer<Plugin, PluginAction> {
        switch plugin.id {
        case .openAI:
            OpenAIPlugin()
        case .ping:
            PingPlugin()
        case .split:
            PingPlugin()
        }
    }
    
    var body: some Reducer<Chat, PluginAction> {
        Reduce { state, action in
            var effects: [Effect<PluginAction>] = []
            switch action {
                
            case 
                .onMessageSent(let update),
                .onMessageReceived(let update),
                .send(let update):
                if update.chatId != state.id {
                    return .none
                }
            }
            
            for var plugin in state.plugins {
                let pluginReducer = reducer(for: plugin)
                let effect = pluginReducer.reduce(into: &plugin, action: action)
                effects.append(effect)
            }
            return .merge(effects)
        }
    }
}

@Reducer
struct PingPlugin {
    var body: some Reducer<Plugin, PluginAction> {
        Reduce { state, action in
            switch action {
            case let .onMessageReceived(chatUpdate):
                if chatUpdate.message.content.starts(with: "/ping") {
                    var ping1 = chatUpdate
                    var ping2 = chatUpdate
                    var ping3 = chatUpdate
                    var ping4 = chatUpdate
                    ping1.message = Message(content: "ping 🏓", sender: state.user)
                    ping2.message = Message(content: "🏏 pong", sender: state.user)
                    ping3.message = Message(content: "ping 🏓", sender: state.user)
                    ping4.message = Message(content: "🏏 pong", sender: state.user)
                    
                    return .concatenate(
                        .send(.onMessageReceived(ping1)),
                        .send(.onMessageReceived(ping2)),
                        .send(.onMessageReceived(ping3)),
                        .send(.onMessageReceived(ping4))
                    )
                }
                return .none
            default:
                return .none
            }
        }
    }
}


@Reducer
struct OpenAIPlugin {
    @Dependency(\.openAIClient) var openAIClient
    @Dependency(\.mainQueue) var queue
    
    var body: some Reducer<Plugin, PluginAction> {
        Reduce { state, action in
            switch action {
            case .onMessageReceived:
                return .none
                
            case let .onMessageSent(chatUpdate):
                var effects: [Effect<PluginAction>] = []
                
                if chatUpdate.message.content.starts(with: "/chat") {
                    let message = chatUpdate
                        .message
                        .content
                        .replacingOccurrences(of: "/chat ", with: "") + " em 5 linhas"
                    
                    effects.append(
                        .publisher {
                            openAIClient.send(message)
                                .receive(on: DispatchQueue.main)
                                .flatMap { [user = state.user] in
                                    let openAIChatUpdate = ChatUpdate.from(
                                        update: chatUpdate,
                                        message: Message(content: $0, sender: user)
                                    )
                                    return [
                                        PluginAction.send(openAIChatUpdate),
                                        PluginAction.onMessageReceived(openAIChatUpdate)
                                    ].publisher
                                }
                        }
                    )
                }
                
                if chatUpdate.message.content.starts(with: "/about") {
                    let aboutUpdate = ChatUpdate.from(
                        update: chatUpdate,
                        message: Message(
                            content: "Sobre OpenAI Plugin: permite você conversar com um modelo LLM :D",
                            sender: state.user
                        )
                    )
                    effects.append(.send(.send(aboutUpdate)))
                    effects.append(.send(.onMessageReceived(aboutUpdate)))
                }
                
                return .concatenate(effects)
            default:
                return .none
            }
        }
    }
}
