import CasePaths
import Foundation
import SwiftUI

struct ChatDetailFeature: Feature {
    struct State: Equatable, Identifiable, Hashable {
        let id: ChatID
        var name: String
        var messages: [MessageFeature.State]
        var inputText: String
        
        init(chat: Chat, inputText: String = "") {
            self.id = chat.id
            self.name = chat.name
            self.messages = chat.messages.map { MessageFeature.State(message: $0) }
            self.inputText = inputText
        }
    }
    
    @CasePathable
    enum Action {
        case message(MessageFeature.Action, MessageFeature.State.ID)
        case updateInputText(String)
        case send
        case sent(ChatID, MessageID)
    }
    
    static let reducer = ReducerOf<Self>.combine(
        Reducer { state, action in
            switch action {
            case .message:
                return .none
            
            case let .updateInputText(update):
                state.inputText = update
                return .none
                
            case .send:
                let newMessage = Message(content: state.inputText)
                let newMessageState = MessageFeature.State(message: newMessage, isSent: false)
                let chatId = state.id
                
                state.messages.append(newMessageState)
                state.inputText = ""
                
                return .publisher(
                    chatClient.send(newMessage, state.id)
                        .map { .sent(chatId, newMessage.id) }
                )
            case .sent:
                return .none
            }
        },
        .forEach(state: \.messages, action: \.message) {
            MessageFeature.reducer
        }
    )
}

struct ChatDetailView: View {
    let store: Store<ChatDetailFeature.State, ChatDetailFeature.Action>
    
    var body: some View {
        WithViewStore(store: store) { viewStore in
            VStack {
                List {
                    ForEach(viewStore.messages) { message in
                        MessageView(store: store.scope(state: { _ in message }, action: \.message))
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
                        set: { viewStore.send(.updateInputText($0)) }
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
            .navigationTitle(viewStore.name)
        }
    }
}



