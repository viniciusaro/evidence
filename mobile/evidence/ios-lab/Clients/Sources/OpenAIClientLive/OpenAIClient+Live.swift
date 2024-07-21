import Combine
import Dependencies
import Foundation
import OpenAIClient

extension OpenAIClient: DependencyKey {
    public static let liveValue = OpenAIClient { message in
        @Dependency(\.urlSession) var urlSession
        let subject = CurrentValueSubject<String, Never>("...")
        
        let url = URL(string: "https://us-central1-evidence-9f05e.cloudfunctions.net/geminiBot")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        let body = ["message": message]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                subject.send(string)
            } else {
                subject.send("error \(error?.localizedDescription ?? "unknown")")
            }
        }
        
        task.resume()
        
        return subject
            .handleEvents(receiveCancel: { task.cancel() })
            .eraseToAnyPublisher()
    }
}
