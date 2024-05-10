import Combine
import Dependencies

public struct OpenAIClient {
    public let send: (String) -> AnyPublisher<String, Never>
}

extension OpenAIClient: TestDependencyKey {
    public static let testValue = OpenAIClient.echo
    public static let previewValue = OpenAIClient.echo
}

extension DependencyValues {
    public var openAIClient: OpenAIClient {
        get { self[OpenAIClient.self] }
        set { self[OpenAIClient.self] = newValue }
    }
}

extension OpenAIClient {
    public static let echo = OpenAIClient { message in
        Just(message).eraseToAnyPublisher()
    }
}
