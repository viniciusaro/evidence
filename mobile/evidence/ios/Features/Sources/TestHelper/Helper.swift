import Combine
import XCTest
import Dependencies
import CustomDump

public struct Step<State> {
    let run: (inout State) -> Void
    let file: StaticString
    let line: UInt
    
    public init(mutation: @escaping (inout State) -> Void, file: StaticString = #file, line: UInt = #line) {
        self.run = mutation
        self.file = file
        self.line = line
    }
}

public func assert<State: Equatable>(
    publisher: Published<State>.Publisher,
    act: @escaping () -> Void,
    withDependencies: ((inout DependencyValues) throws -> Void)? = nil,
    steps: [Step<State>],
    file: StaticString = #file,
    line: UInt = #line
) {
    let operation = {
        var mutations = steps
        var expected: State!
        let expectation = XCTestExpectation(description: "states received")
        var subscription: AnyCancellable? = publisher.sink { state in
            if expected == nil {
                expected = state
                return
            }
            
            if (mutations.isEmpty) {
                XCTFail("unexpected state \(String(customDumping: state))", file: file, line: line)
                return
            }
            let mutation = mutations.removeFirst()
            mutation.run(&expected)
            XCTAssertNoDifference(state, expected, file: mutation.file, line: mutation.line)
            if (mutations.isEmpty) {
                expectation.fulfill()
            }
        }
        act()
        if XCTWaiter.wait(for: [expectation], timeout: 0.5) != .completed {
            XCTFail(
                "steps not found: \(String(customDumping: mutations))",
                file: mutations.first?.file ?? file,
                line: mutations.first?.line ?? line
            )
        }
        subscription = nil
        _ = subscription
    }
    
    do {
        try Dependencies.withDependencies {
            try withDependencies?(&$0)
        } operation: {
            operation()
        }
    } catch {
        XCTFail("operation \(error)", file: file, line: line)
    }
}
