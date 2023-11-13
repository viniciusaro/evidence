import Combine
import Dependencies
import Models
import SwiftUI

struct MessageViewState: Equatable {
    var loading: Bool
    var message: Message
    var preview: Preview?
    
    init(message: Message, loading: Bool = false, preview: Preview? = nil) {
        self.loading = loading
        self.message = message
        self.preview = preview
    }
    
    struct Preview: Equatable {
        let image: URL
        let title: String
    }
}

class MessageViewModel: ObservableObject, Identifiable {
    @Published private(set) var state: MessageViewState
    @Dependency(\.urlPreviewClient) var urlPreviewClient
    
    var id: UUID { self.state.message.id }
    private var previewCancellable: AnyCancellable?
    
    init(message: Message, 
         loading: Bool = false,
         preview: MessageViewState.Preview? = nil
    ) {
        self.state = MessageViewState(
            message: message,
            loading: loading,
            preview: preview
        )
    }
    
    func onLoad() {
        guard let url = URL(string: self.state.message.content),
            url.host() != nil,
            self.state.preview == nil else { return }
        
        self.state.loading = true
        self.previewCancellable = self.urlPreviewClient.get(url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.state.loading = false
                guard let (image, title) = $0 else { return }
                self?.state.preview = .init(image: image, title: title)
            }
    }
}

struct MessageView: View {
    @ObservedObject var model: MessageViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(self.model.state.message.content)
                Spacer()
                if self.model.state.loading {
                    ProgressView()
                }
            }
            if let preview = self.model.state.preview {
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
