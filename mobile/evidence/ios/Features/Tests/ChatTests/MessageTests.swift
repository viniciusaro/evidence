import Combine
import Dependencies
import XCTest
@testable import Chat

class MessageTests: XCTestCase {
    func testOnLoadSuccess() async throws {
        let image = URL(string: "url")!
        let title = "title"
        
        try await withDependencies {
            $0.urlPreviewClient = .init { _ in Just((image, title)).eraseToAnyPublisher() }
        } operation: {
            let viewModel = MessageViewModel(message: .link)
            
            XCTAssertEqual(viewModel.loading, false)
            viewModel.onLoad()
            try await Task.sleep(nanoseconds: 100_000)
            XCTAssertEqual(viewModel.preview, MessageViewModel.Preview(image: image, title: title))
            XCTAssertEqual(viewModel.loading, false)
        }
    }
    
    func testOnLoadFailure() async throws {
        try await withDependencies {
            $0.urlPreviewClient = .init { _ in Just(nil).eraseToAnyPublisher() }
        } operation: {
            let viewModel = MessageViewModel(message: .link)
            
            XCTAssertEqual(viewModel.loading, false)
            
            viewModel.onLoad()
            try await Task.sleep(nanoseconds: 100_000)
            XCTAssertEqual(viewModel.preview, nil)
            XCTAssertEqual(viewModel.loading, false)
        }
    }
}
