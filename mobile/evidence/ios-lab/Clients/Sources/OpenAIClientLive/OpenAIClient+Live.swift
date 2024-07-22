import Combine
import Dependencies
import FirebaseFunctions
import Foundation
import OpenAIClient

extension OpenAIClient: DependencyKey {
    public static let liveValue = OpenAIClient { message in
        @Dependency(\.urlSession) var urlSession
        
        let subject = CurrentValueSubject<String, Never>("...")
        
        let functions = Functions.functions()
        var callable: HTTPSCallable? = functions.httpsCallable("geminiBotCallable")
            
        callable?.call(["message": message]) { result, error in
            if let data = result?.data as? String {
                subject.send(data)
            } else if let error = error {
                subject.send("error: \(error.localizedDescription)")
            } else {
                subject.send("error: unknown")
            }
        }

        return subject
            .handleEvents(receiveCancel: { callable = nil })
            .eraseToAnyPublisher()
    }
}
