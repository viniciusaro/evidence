import XCTest
import TestHelper

@testable import Chat

class MessageTests: XCTestCase {
    func testOnViewAppearSuccess() {
        let image = URL(string: "url")!
        let title = "title"
        let viewModel = MessageViewModel(state: MessageViewState(message: .link))
        
        assert(
            publisher: viewModel.$state,
            act: { viewModel.onViewAppear() },
            withDependencies: { $0.urlPreviewClient = .sync((image, title)) },
            steps: [
                Step { $0.loading = true },
                Step { $0.loading = false },
                Step { $0.preview = .init(image: image, title: title) },
            ]
        )
    }
    
    func testOnViewAppearFailure() {
        let viewModel = MessageViewModel(state: MessageViewState(message: .link))
        
        assert(
            publisher: viewModel.$state,
            act: { viewModel.onViewAppear() },
            withDependencies: { $0.urlPreviewClient = .sync(nil) },
            steps: [
                Step { $0.loading = true },
                Step { $0.loading = false }
            ]
        )
    }
}
