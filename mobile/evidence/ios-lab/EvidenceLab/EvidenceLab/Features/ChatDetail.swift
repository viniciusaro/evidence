import CasePaths
import Foundation
import IdentifiedCollections
import SwiftUI

#Preview {
    ChatDetailView(
        store: Store(
            initialState: ChatDetailFeature.State(chat: .lili),
            reducer: ChatDetailFeature.reducer
        )
    )
}

struct ChatDetailFeature: Feature {
    struct State: Equatable, Hashable {
        var chat: Chat
        var inputText: String
        var messages: IdentifiedArrayOf<MessageFeature.State>
        
        init(chat: Chat, inputText: String = "") {
            self.chat = chat
            self.inputText = inputText
            self.messages = IdentifiedArray(
                uniqueElements: chat.messages.map { MessageFeature.State(message: $0) }
            )
        }
    }
    
    @CasePathable
    enum Action {
        case inputTextUpdated(String)
        case message(MessageFeature.Action, MessageID)
        case send
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case let .inputTextUpdated(update):
                state.inputText = update
                return .none

            case .message:
                return .none            
                
            case .send:
                let newMessage = Message(content: state.inputText)
                let newMessageState = MessageFeature.State(message: newMessage)
                let chatId = state.chat.id
                state.messages.append(newMessageState)
                state.inputText = ""
                return .none
            }
        },
        .forEach(state: \.messages, action: \.message, id: \.message.id) {
            MessageFeature.reducer
        }
    )
    .onChange(state: \.messages) { state, updatedMessageStates in
        state.chat.messages = updatedMessageStates.map { $0.message }
    }
}

struct ChatDetailView: View {
    let store: Store<ChatDetailFeature.State, ChatDetailFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack {
                List {
                    ForEach(viewStore.messages, id: \.message.id) { message in
                        MessageView(store: store.scope(
                            state: { _ in message },
                            action: \.message,
                            id: \.message.id
                        ))
                    }
                }
                .listStyle(.plain)
                HStack(spacing: 12) {
                    Button(action: {
                        
                    }, label: {
                        Label("", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .font(.title)
                            .foregroundStyle(.primary)
                    })
                    TextField("", text: Binding(
                        get: { viewStore.inputText },
                        set: { viewStore.send(.inputTextUpdated($0)) }
                    ))
                    .frame(height: 36)
                    .padding([.leading, .trailing], 8)
                    .background(RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                    )
                    Button(action: {
                        viewStore.send(.send)
                    }, label: {
                        Label("", systemImage: "arrow.forward.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.largeTitle)
                            .foregroundStyle(.white, .primary)
                    })
                }
                .padding(10)
                .background(Color(red: 20/255, green: 20/255, blue: 20/255))
            }
            .navigationTitle(viewStore.chat.name)
        }
    }
}



