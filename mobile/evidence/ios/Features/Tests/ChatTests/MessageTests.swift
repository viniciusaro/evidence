import Combine
import XCTest
@testable import Chat

class MessageTests: XCTestCase {
    func testOnLoadSuccess() async throws {
        let image = URL(string: "url")!
        let title = "title"
        let client = URLPreviewClient { _ in Just((image, title)).eraseToAnyPublisher() }
        let viewModel = MessageViewModel(message: .link, urlPreviewClient: client)
        
        XCTAssertEqual(viewModel.loading, false)
        
        viewModel.onLoad()
        try await Task.sleep(nanoseconds: 100_000)
        XCTAssertEqual(viewModel.preview, MessageViewModel.Preview(image: image, title: title))
        XCTAssertEqual(viewModel.loading, false)
    }
    
    func testOnLoadFailure() async throws {
        let client = URLPreviewClient { _ in Just(nil).eraseToAnyPublisher() }
        let viewModel = MessageViewModel(message: .link, urlPreviewClient: client)
        
        XCTAssertEqual(viewModel.loading, false)
        
        viewModel.onLoad()
        try await Task.sleep(nanoseconds: 100_000)
        XCTAssertEqual(viewModel.preview, nil)
        XCTAssertEqual(viewModel.loading, false)
    }
}
