import Combine
import Dependencies
import Leaf
import Models
import SwiftUI

public struct MessageFeature {
    @Dependency(\.urlPreviewClient) static var urlPreviewClient
    
    public struct State: Equatable, Hashable {
        var loading: Bool = false
        var message: Message
        var preview: Preview?
        
        public init(loading: Bool = false, message: Message, preview: Preview? = nil) {
            self.loading = loading
            self.message = message
            self.preview = preview
        }
    }
    
    public struct Preview: Equatable, Hashable {
        let image: URL
        let title: String
    }
    
    public enum Action {
        case onViewAppear
        case onPreviewLoaded(Preview)
        case onPreviewLoadError
    }
    
    public static func reducer(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onViewAppear:
            guard let url = state.url, state.preview == nil else { return .none }
            state.loading = true
            return .publisher(
                urlPreviewClient.get(url)
                    .map { .onPreviewLoaded(.init($0)) }
                    .replaceError(with: .onPreviewLoadError)
                    .receive(on: DispatchQueue.main)
            )
            
        case let .onPreviewLoaded(preview):
            state.loading = false
            state.preview = preview
            return .none
            
        case .onPreviewLoadError:
            return .none
        }
    }
}

extension MessageFeature.State {
    var url: URL? {
        let url = URL(string: message.content)
        return url?.host() != nil ? url : nil
    }
}

extension MessageFeature.State: Identifiable {
    public var id: UUID { self.message.id }
}

extension MessageFeature.Preview {
    init(_ tuple: (image: URL, title: String)) {
        self.image = tuple.image
        self.title = tuple.title
    }
}

struct MessageView: View {
    @ObservedObject var store: Store<MessageFeature.State, MessageFeature.Action>
    
    var body: some View {
        VStack(spacing: 16) {
            Text(self.store.state.message.content)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let preview = self.store.state.preview {
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
                        .lineLimit(1)
                        .font(.caption)
                }
            } else if self.store.state.loading {
                VStack(alignment: .leading) {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 100)
                    Text("loading")
                        .redacted(reason: .placeholder)
                        .font(.caption)
                }
            }
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .onAppear { self.store.send(.onViewAppear) }
    }
}

#Preview {
    LeafThemeView {
        MessageView(
            store: Store(
                state: MessageFeature.State(message: .link),
                reducer: MessageFeature.reducer
            )
        )
    }
}
