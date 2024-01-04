import CasePaths
import Dependencies
import Leaf
import Models
import SwiftUI

public struct ChatFeature {
    @Dependency(\.suspendingClock) static private var clock
    @Dependency(\.mainQueue) static private var mainQueue
    
    public struct State {
        public var messages: [MessageFeature.State]
        var highlightedMessageId: MessageFeature.State.ID?
        var scrollToMessageId: MessageFeature.State.ID?
        var tempHighlightedMessageId: MessageFeature.State.ID?
        
        public init(
            messages: [MessageFeature.State],
            highlightedMessageId: MessageFeature.State.ID? = nil
        ) {
            self.messages = messages
            self.highlightedMessageId = nil
            self.scrollToMessageId = nil
            self.tempHighlightedMessageId = highlightedMessageId
        }
    }
    
    @CasePathable
    public enum Action {
        case onViewAppear
        case highlightMessageIfNeeded
        case highlight(MessageFeature.State.ID)
        case removeHighlight
        case scrollToMessageId(MessageFeature.State.ID?)
        case message((MessageFeature.Action, Int))
    }
    
    public static func reducer(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onViewAppear:
            return .sync(.highlightMessageIfNeeded)
        
        case let .highlight(id):
            state.scrollToMessageId = id
            state.highlightedMessageId = id
            return .run { send in
                Task {
                    try? await self.clock.sleep(for: .seconds(2))
                    self.mainQueue.schedule {
                        send(.removeHighlight)
                    }
                }
            }
            
        case .removeHighlight:
            state.scrollToMessageId = nil
            state.highlightedMessageId = nil
            return .none
            
        case .highlightMessageIfNeeded:
            guard let id = state.tempHighlightedMessageId else { return .none }
            state.tempHighlightedMessageId = nil
            return .run { send in
                Task {
                    try? await self.clock.sleep(for: .seconds(1))
                    self.mainQueue.schedule {
                        send(.highlight(id))
                    }
                }
            }
            
        case .scrollToMessageId:
            return .none
            
        case .message:
            return .none
        }
    }
}

extension ChatFeature.State {
    public func isHighlighted(_ messageModel: MessageFeature.State) -> Bool {
        return messageModel.id == self.highlightedMessageId
    }
}

public struct ChatView: View {
    @ObservedObject var store: Store<ChatFeature.State, ChatFeature.Action>
    @Environment(\.leafTheme) var theme
    
    public init(store: Store<ChatFeature.State, ChatFeature.Action>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(self.store.state.messages.enumerated()), id: \.element.id) { index, messageState in
                        MessageView(
                            store: self.store.scope(
                                state: { _ in messageState },
                                action: { .message(($0, index)) }
                            )
                        )
                        .background(
                            self.store.state.isHighlighted(messageState) ?
                            self.theme.color.brand.secondary : nil
                        )
                        .animation(
                            Animation.easeIn,
                            value: self.store.state.isHighlighted(messageState)
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: .constant(self.store.state.scrollToMessageId))
            .navigationTitle("Chat")
        }
        .onAppear { self.store.send(.onViewAppear) }
    }
}

#Preview {
    ChatView(
        store: Store(
            state: ChatFeature.State(
                messages: [
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                    Message.mac(id: UUID(1)),
                    Message.vini("hi"),
                    Message.vini("hello"),
                    Message.vini("howAreYouDoing"),
                ].map {
                    .init(message: $0)
                },
                highlightedMessageId: UUID(1)
            ),
            reducer: combine(
                ChatFeature.reducer,
                forEach(
                    MessageFeature.reducer,
                    state: \.messages,
                    action: AnyCasePath(\ChatFeature.Action.Cases.message)
                )
            )
        )
    )
}
