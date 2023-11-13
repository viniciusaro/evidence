import Combine
import Dependencies
import Models
import SwiftUI

class MessageViewModel: ObservableObject, Identifiable {
    @Published private(set) var loading: Bool
    @Published private(set) var message: Message
    @Published private(set) var preview: Preview?
    @Dependency(\.urlPreviewClient) var urlPreviewClient
    
    var id: UUID { self.message.id }
    private var previewCancellable: AnyCancellable?
    
    struct Preview: Equatable {
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
        self.previewCancellable = self.urlPreviewClient.get(url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loading = false
                guard let (image, title) = $0 else { return }
                self?.preview = MessageViewModel.Preview(image: image, title: title)
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
