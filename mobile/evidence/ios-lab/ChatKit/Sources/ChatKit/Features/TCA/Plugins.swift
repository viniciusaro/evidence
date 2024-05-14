import Combine
import ComposableArchitecture
import Foundation
import Models

public enum PluginAction {
    case onMessageSent(ChatUpdate)
    case onMessageReceived(ChatUpdate)
    case send(ChatUpdate)
}

struct PluginReducer<State, Action>: Reducer {
    let action: CaseKeyPath<Action, PluginAction>
    let child: () -> any Reducer<Void, PluginAction>
    
    var body: some Reducer<State, Action> {
        Reduce { _, action in
            if let childAction = AnyCasePath(self.action).extract(from: action) {
                var fakeState: Void = ()
                let effect = child().reduce(into: &fakeState, action: childAction)
                let parentEffect = effect.map { pluginAction in
                    AnyCasePath(self.action).embed(pluginAction)
                }
                return parentEffect
            }
            return .none
        }
    }
}

@Reducer
struct PingPlugin {
    var body: some Reducer<Void, PluginAction> {
        Reduce { state, action in
            switch action {
            case let .onMessageSent(chatUpdate):
                if chatUpdate.message.content.lowercased() == "ping" {
                    var ping1 = chatUpdate
                    var ping2 = chatUpdate
                    var ping3 = chatUpdate
                    var ping4 = chatUpdate
                    ping1.message = Message(content: "ping 🏓", sender: .echo)
                    ping2.message = Message(content: "🏏 pong", sender: .echo)
                    ping3.message = Message(content: "ping 🏓", sender: .echo)
                    ping4.message = Message(content: "🏏 pong", sender: .echo)
                    
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
struct AutoCorrectPlugin {
    var body: some Reducer<Void, PluginAction> {
        Reduce { state, action in
            switch action {
            case var .onMessageReceived(chatUpdate):
                if chatUpdate.message.content.lowercased() == "🏏 pong" {
                    chatUpdate.message.content = "🏏 pongui (auto corrected)"
                    return .send(.onMessageReceived(chatUpdate))
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
    
    var body: some Reducer<Void, PluginAction> {
        Reduce { state, action in
            switch action {
            case let .onMessageReceived(chatUpdate):
                if chatUpdate.message.content.starts(with: "/openai")  {
                    var update = chatUpdate
                    update.message.content = update.message.content.replacingOccurrences(of: "/openai ", with: "")
                    return .send(.onMessageReceived(update))
                }
                return .none
                
            case let .onMessageSent(chatUpdate):
                if chatUpdate.message.content.starts(with: "/openai")  {
                    var copy = chatUpdate
                    copy.message.content = copy.message.content.replacingOccurrences(of: "/openai ", with: "")
                    
                    return .merge(
                        .send(.onMessageReceived(copy)),
                        .publisher {
                            openAIClient.send(chatUpdate.message.content)
                                .receive(on: DispatchQueue.main)
                                .flatMap {
                                    var update = chatUpdate
                                    update.message = Message(content: $0, sender: .openAI)
                                    return [
                                        PluginAction.send(update),
                                        PluginAction.onMessageReceived(update)
                                    ].publisher
                                }
                        }
                    )
                }
                return .none
            default:
                return .none
            }
        }
    }
}
