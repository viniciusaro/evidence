//
//  AvatarView.swift
//  Evidence
//
//  Created by Cris Messias on 28/09/23.
//

import SwiftUI
import CachedAsyncImage //Package Dependencies


struct AvatarView: View {
    let urlImage: URL?
    
    var body: some View {
        CachedAvatarImage(url: urlImage)
    }
}

#Preview {
    AvatarView(urlImage: URL(string: "https://shorturl.at/uyWY2"))
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
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sizeImage, height: sizeImage)
            .foregroundColor(.gray)
            .cornerRadius(sizeImage/2)
            .overlay {
                Circle()
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: sizeCircle, height: sizeCircle)
            }
    }
}


struct ImageView: View {
    let sizeImage: CGFloat = 43
    let sizeCircle: CGFloat = 50
    var systemImage: String
    
    var body: some View {
        Image(systemName: systemImage )
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: sizeImage, height: sizeImage)
            .foregroundColor(.gray)
            .cornerRadius(sizeImage/2)
            .overlay {
                Circle()
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: sizeCircle, height: sizeCircle)
            }
    }
}
