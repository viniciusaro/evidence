import Combine
import Models
import SwiftUI

class MessageViewModel: ObservableObject, Identifiable {
    @Published private(set) var loading: Bool
    @Published private(set) var message: Message
    @Published private(set) var preview: Preview?
    
    var id: UUID { self.message.id }
    private var previewCancellable: AnyCancellable?
    
    struct Preview {
        let image: URL
        let title: String
    }
    
    init(message: Message, loading: Bool = false, preview: Preview? = nil) {
        self.message = message
        self.loading = loading
        self.preview = preview
    }
    
    func onLoad() {
        guard let url = URL(string: self.message.content),
            url.host() != nil,
            self.preview == nil else { return }
        
        self.loading = true
        self.previewCancellable = requestPreview(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.preview = $0
                self?.loading = false
            }
    }
}

struct MessageView: View {
    @ObservedObject var model: MessageViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(self.model.message.content)
                Spacer()
                if self.model.loading {
                    ProgressView()
                }
            }
            if let preview = self.model.preview {
                VStack(alignment: .leading) {
                    AsyncImage(
                        url: preview.image,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .clipped()
                        },
                        placeholder: {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 100)
                        }
                    )
                    Text(preview.title)
                        .font(.caption)
                }
            }
        }
        .task { self.model.onLoad() }
    }
}

func requestPreview(url: URL) -> AnyPublisher<MessageViewModel.Preview?, Never> {
    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
    request.allHTTPHeaderFields = [
        "cookie": "ilo0=false",
    ]
    return URLSession.shared.dataTaskPublisher(for: request)
        .map { data, _ in data }
        .map { String(decoding: $0, as: UTF8.self) }
        .map { string in
            guard
                let imageUrlString = string.findMetaProperty("image"),
                let image = URL(string: String(imageUrlString)),
                let title = string.findMetaProperty("title") else {
                return nil
            }
            return MessageViewModel.Preview(image: image, title: title)
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
}

extension String {
    func findMetaProperty(_ property: String) -> String? {
        guard
            let regex = try? Regex("property=\"og:\(property)\" content=\"(.*?)\""),
            let urlStringMatch = try? regex.firstMatch(in: self),
            let urlString = urlStringMatch.output[1].substring else {
                return nil
            }
        return String(urlString)
    }
}
