import ComposableArchitecture
import SwiftUI

@Reducer
struct ChatDetailFeature {
    @ObservableState
    struct State: Equatable, Codable {
        @ObservationStateIgnored
        @Shared var chat: Chat
        var inputText: String = ""
        
        init(chat: Shared<Chat>) {
            self._chat = chat
        }
    }
    enum Action {
        case inputTextUpdated(String)
        case send
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .inputTextUpdated(updatedText):
                state.inputText = updatedText
                return .none
            
            case .send:
                let newMessage = Message(content: state.inputText, sender: .vini)
                state.chat.messages.append(newMessage)
                state.inputText = ""
                return .none
            }
        }
    }
}

struct ChatDetailView: View {
    let store: StoreOf<ChatDetailFeature>
    
    var body: some View {
        VStack {
            List {
                ForEach(store.chat.messages) { message in
                    VStack {
                        Text(message.content)
                            .frame(maxWidth: .infinity)
                        Text(message.sender.name).font(.caption2)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .foregroundStyle(.primary)
                })
                TextField("", text: Binding(
                    get: { store.inputText },
                    set: { store.send(.inputTextUpdated($0)) }
                ))
                .frame(height: 36)
                .padding([.leading, .trailing], 8)
                .background(RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 43/255, green: 43/255, blue: 43/255))
                )
                Button(action: {
                    store.send(.send)
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
        .listStyle(.plain)
    }
}
