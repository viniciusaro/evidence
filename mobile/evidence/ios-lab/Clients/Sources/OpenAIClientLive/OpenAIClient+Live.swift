import Combine
import Dependencies
import OpenAIClient
import GoogleGenerativeAI

extension OpenAIClient: DependencyKey {
    public static let liveValue = OpenAIClient { message in
        let subject = CurrentValueSubject<String, Never>("...")
        
        let model = GenerativeModel(
            name: "gemini-pro",
            apiKey: "AIzaSyAef5as2EWkxe9rUNw7NORHaMAZeroRD80"
        )
        
        let task = Task {
            let response = try await model.generateContent(message)
            if let text = response.text {
                subject.send(text)
            }
        }
        
        return subject
            .handleEvents(receiveCancel: { task.cancel() })
            .eraseToAnyPublisher()
    }
}
