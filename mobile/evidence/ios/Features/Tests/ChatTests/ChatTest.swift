import Dependencies
import Models
import XCTest
import TestHelper

@testable import Chat

@MainActor
final class ChatTest: XCTestCase {
    func testHighlightsMessage() {
        let messages = [
            Message.vini(id: UUID(0), "Hi"),
            Message.kristem(id: UUID(1), "Hello"),
        ]
        
        let viewModel = ChatViewModel(
            state: ChatViewState(
                messages: messages.map { MessageViewModel(state: .init(message: $0)) },
                highlightedMessageId: UUID(0)
            )
        )
        
        assert(
            publisher: viewModel.$state,
            act: { viewModel.onViewAppear() },
            withDependencies: { $0.suspendingClock = ImmediateClock() },
            steps: [
                Step { $0.tempHighlightedMessageId = nil },
                Step { $0.scrollToMessageId = UUID(0) },
                Step { $0.highlightedMessageId = UUID(0) },
                Step { $0.scrollToMessageId = nil },
                Step { $0.highlightedMessageId = nil },
            ]
        )
    }
    
    func testIsHighlighted() async {
        let clock = TestClock()
        
        let messageModel = MessageViewModel(
            state: MessageViewState(message: .vini(id: UUID(0), "Hi"))
        )
        
        let viewModel = ChatViewModel(
            state: ChatViewState(messages: [messageModel], highlightedMessageId: UUID(0))
        )
        
        await withDependencies {
            $0.suspendingClock = clock
        } operation: {
            viewModel.onViewAppear()
            
            await clock.advance(by: .seconds(1))
            XCTAssertEqual(viewModel.isHighlighted(messageModel), true)
            
            await clock.advance(by: .seconds(2))
            XCTAssertEqual(viewModel.isHighlighted(messageModel), false)
        }
    }
}
