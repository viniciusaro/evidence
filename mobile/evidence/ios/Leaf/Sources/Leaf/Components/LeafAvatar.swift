import SwiftUI

public struct LeafAvatar: View {
    private let url: URL
    @Environment(\.leafAvatarStyle) private var style
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        let configuration = LeafAvatarConfiguration(avatar: AnyView(
            LeafAsyncImage(url: url) { status in
                switch status {
                case .loading:
                    ProgressView()
                case .loaded(let image):
                    image.resizable()
                case .error(_):
                    Image(systemName: "exclamationmark.circle.fill").resizable()
                }
            }
        ))
        AnyView(style.makeBody(configuration: configuration))
    }
}

#Preview {
    LeafThemeView {
        HStack {
            LeafAvatar(url: URL.documentsDirectory)
                .avatarStyle(.evident)
            LeafAvatar(url: URL.documentsDirectory)
                .avatarStyle(.automatic)
        }
    }
}
