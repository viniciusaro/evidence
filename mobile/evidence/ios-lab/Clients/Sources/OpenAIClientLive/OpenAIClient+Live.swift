import Dependencies
import OpenAIClient

extension OpenAIClient: DependencyKey {
    public static let liveValue = OpenAIClient.echo
}
