import Combine
import Dependencies
import Leaf
import Models
import SwiftUI
import Leaf

public struct MessageViewState: Equatable {
    public var loading: Bool
    public var message: Message
    public var preview: Preview?
    
    public struct Preview: Equatable {
        let image: URL
        let title: String
    }
    
    public init(
        message: Message,
        loading: Bool = false, 
        preview: Preview? = nil
    ) {
        self.loading = loading
        self.message = message
        self.preview = preview
    }
}

public class MessageViewModel: Equatable, ObservableObject, Identifiable {
    @Published private(set) var state: MessageViewState
    @Dependency(\.urlPreviewClient) private var urlPreviewClient
    
    public var id: UUID { self.state.message.id }
    private var previewCancellable: AnyCancellable?
    
    public init(state: MessageViewState) {
        self.state = state
        self.startWithLoadingIfTheresPreview()
    }
    
    func onViewAppear() {
        self.loadPreviewIfNeeded()
    }
    
    private func startWithLoadingIfTheresPreview() {
        if let url = URL(string: self.state.message.content),
           url.host() != nil,
           self.state.preview == nil {
                self.state.loading = true
        }
    }
    
    private func loadPreviewIfNeeded() {
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
    
    public static func == (lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
        lhs.state == rhs.state
    }
}

struct MessageView: View {
    @ObservedObject var model: MessageViewModel
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        VStack(spacing: 16) {
            Text(self.model.state.message.content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .body()
            if let preview = self.model.state.preview {
                VStack(alignment: .leading) {
                    LeafAsyncImage(url: preview.image) { status in
                        switch status {
                        case let .loaded(image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .clipped()
                        case .loading, .error:
                            Rectangle()
                                .opacity(0)
                                .frame(height: 100)
                        }
                    }
                    Text(preview.title)
                        .link()
                        .lineLimit(1)
                        .foregroundStyle(theme.color.system.primary)
                }
            } else if self.model.state.loading {
                VStack(alignment: .leading) {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 100)
                    Text("loading")
                        .redacted(reason: .placeholder)
                        .body()
                }
            }
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .onAppear { self.model.onViewAppear() }
    }
}

#Preview {
    LeafThemeView {
        MessageView(
            model: MessageViewModel(
                state: .init(message: .link)
            )
        )
    }
    .previewCustomFonts()
}
