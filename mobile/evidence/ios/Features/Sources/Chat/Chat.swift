import Dependencies
import Leaf
import Models
import SwiftUI

public struct ChatViewState: Equatable {
    var messages: [MessageViewModel]
    var highlightedMessageId: MessageViewModel.ID?
    var scrollToMessageId: MessageViewModel.ID?
    var tempHighlightedMessageId: MessageViewModel.ID?
    
    public init(
        messages: [MessageViewModel],
        highlightedMessageId: MessageViewModel.ID? = nil
    ) {
        self.messages = messages
        self.highlightedMessageId = nil
        self.scrollToMessageId = nil
        self.tempHighlightedMessageId = highlightedMessageId
    }
}

@MainActor
public class ChatViewModel: ObservableObject {
    @Published var state: ChatViewState
    @Dependency(\.suspendingClock) private var clock

    private var highlightTask: Task<(), Never>?
    
    public init(state: ChatViewState) {
        self.state = state
    }
    
    public func onViewAppear() {
        self.highlightMessageIfNeeded();
    }
    
    public func isHighlighted(_ messageModel: MessageViewModel) -> Bool {
        return messageModel.id == self.state.highlightedMessageId
    }
    
    private func highlightMessageIfNeeded() {
        self.highlightTask = Task { [weak self] in
            guard
                let self = self,
                let id = self.state.tempHighlightedMessageId else { return }
            
            self.state.tempHighlightedMessageId = nil
            try? await self.clock.sleep(for: .seconds(1))
            
            self.state.scrollToMessageId = id
            self.state.highlightedMessageId = id
            
            try? await self.clock.sleep(for: .seconds(2))
            self.state.scrollToMessageId = nil
            self.state.highlightedMessageId = nil
        }
    }
    
    deinit {
        self.highlightTask?.cancel()
        self.highlightTask = nil
    }
}

public struct ChatView: View {
    @ObservedObject var model: ChatViewModel
    @Environment(\.leafTheme) var theme
    
    public init(model: ChatViewModel) {
        self.model = model
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(self.model.state.messages) { messageModel in
                        MessageView(model: messageModel)
                            .background(
                                self.model.isHighlighted(messageModel) ?
                                self.theme.color.system.alert : nil
                            )
                            .animation(
                                Animation.easeIn,
                                value: self.model.isHighlighted(messageModel)
                            )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: self.$model.state.scrollToMessageId)
            .navigationTitle("Chat")
            .font(.bodyLeaf)
            .foregroundStyle(theme.color.system.primary)
        }
        .onAppear { self.model.onViewAppear() }
    }
}

#Preview {
    ChatView(
        model: ChatViewModel(
            state: ChatViewState(
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
                    MessageViewModel(
                        state: MessageViewState(message: $0)
                    )
                },
                highlightedMessageId: UUID(1)
            )
        )
    )
    .previewCustomFonts()
}
