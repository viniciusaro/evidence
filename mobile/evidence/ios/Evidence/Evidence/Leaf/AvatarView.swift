//
//  AvatarView.swift
//  Evidence
//
//  Created by Cris Messias on 28/09/23.
//

import SwiftUI


struct AvatarView: View {
    var imageAvatar: String?

    var body: some View {
                if let image = imageAvatar {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(80 / 2)
                        .overlay {
                            Circle()
                                .stroke(Color.gray, lineWidth: 3)
                                .frame(width: 80, height: 80)
                        }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                        .cornerRadius(80/2)
                        .overlay {
                            Circle()
                                .stroke(Color.gray, lineWidth: 3)
                                .frame(width: 80, height: 80)
                        }
                }
    }

}


struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView()
        AvatarView(imageAvatar: "avatar")
    }
}
