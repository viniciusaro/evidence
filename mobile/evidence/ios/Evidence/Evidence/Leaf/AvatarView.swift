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
        CachedAsyncImage(url: urlImage) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 43, height: 43)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 43, height: 43)
                    .foregroundColor(.gray)
                    .cornerRadius(43/2)
                    .overlay {
                        Circle()
                            .stroke(Color.gray, lineWidth: 3)
                            .frame(width: 50, height: 50)
                    }
            case .failure(_):
                SystemImageView(systemImage: "exclamationmark.circle.fill")
            @unknown default:
                SystemImageView(systemImage: "person.circle.fill")
            }
        }
    }
}

struct SystemImageView: View {
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
                    .stroke(Color.gray, lineWidth: 3)
                    .frame(width: sizeCircle, height: sizeCircle)
            }
    }
}


#Preview {
    AvatarView(urlImage: URL(string: "https://www.parismatch.com/lmnr/var/pm/public/media/image/Kristen-Stewart_0.jpg?VersionId=Qvmz.gb9n72R2FTy.F8PVMWaL6SiLrFE"))
}
