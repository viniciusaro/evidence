import Combine
import Dependencies
import OpenAIClient
import GoogleGenerativeAI

extension OpenAIClient: DependencyKey {
    public static let liveValue = OpenAIClient { message in
        let subject = CurrentValueSubject<String, Never>("...")
        
        let model = GenerativeModel(
            name: "gemini-1.5-flash-latest",
            apiKey: "AIzaSyAef5as2EWkxe9rUNw7NORHaMAZeroRD80"
        )
        
        let task = Task {
            do {
                let response = try await model.generateContent(message)
                subject.send(response.text ?? "Ops, resposta fora dos padrões")
            } catch {
                subject.send(error.localizedDescription)
            }
        }
        
        return subject
            .handleEvents(receiveCancel: { task.cancel() })
            .eraseToAnyPublisher()
    }
}
