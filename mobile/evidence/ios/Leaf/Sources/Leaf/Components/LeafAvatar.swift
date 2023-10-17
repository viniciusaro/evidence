import SwiftUI
import CachedAsyncImage

public struct LeafAvatar: View {
    private let url: URL
    @Environment(\.leafAvatarStyle) private var style
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        let configuration = LeafAvatarConfiguration(avatar: AnyView(
            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                case .failure(_):
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                @unknown default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                }
            }
        ))
        
        AnyView(style.makeBody(configuration: configuration))
    }
}

#Preview {
    let url1 = "https://pbs.twimg.com/profile_images/1694966619875708928/rbZorQR2_400x400.jpg"
    let url2 = "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg"
    
    return LeafThemeView {
        HStack {
            LeafAvatar(url: URL(string: url1)!)
                .avatarStyle(.evident)
            LeafAvatar(url: URL(string: url2)!)
                .avatarStyle(.automatic)
        }
    }
}
