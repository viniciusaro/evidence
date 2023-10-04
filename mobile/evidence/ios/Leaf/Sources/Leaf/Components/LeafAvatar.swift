import SwiftUI
import CachedAsyncImage

struct LeafAvatar: View {
    let urlImage: URL?
    
    var body: some View {
        CachedAvatarImage(url: urlImage)
    }
}

#Preview {
    LeafThemeView {
        LeafAvatar(urlImage: URL(string: "https://shorturl.at/uyWY2"))
    }
}

//MARK: View Extraction

struct CachedAvatarImage: View {
    let url: URL?
    
    var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 43, height: 43)
            case .success(let image):
                SuccessImage(image: image)
            case .failure(_):
                ImageView(systemImage: "exclamationmark.circle.fill")
            @unknown default:
                ImageView(systemImage: "person.circle.fill")
            }
        }
    }
}


struct SuccessImage: View {
    let sizeImage: CGFloat = 43
    let sizeCircle: CGFloat = 50
    let image: Image
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sizeImage, height: sizeImage)
            .foregroundColor(theme.color.content.secondary)
            .cornerRadius(sizeImage/2)
            .overlay {
                Circle()
                    .stroke(theme.color.brand.primary, lineWidth: 3)
                    .frame(width: sizeCircle, height: sizeCircle)
            }
    }
}


struct ImageView: View {
    let sizeImage: CGFloat = 43
    let sizeCircle: CGFloat = 50
    var systemImage: String
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        Image(systemName: systemImage )
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sizeImage, height: sizeImage)
            .foregroundColor(theme.color.content.secondary)
            .cornerRadius(sizeImage/2)
            .overlay {
                Circle()
                    .stroke(theme.color.brand.primary, lineWidth: 3)
                    .frame(width: sizeCircle, height: sizeCircle)
            }
    }
}
