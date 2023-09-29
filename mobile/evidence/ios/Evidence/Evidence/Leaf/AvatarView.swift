//
//  AvatarView.swift
//  Evidence
//
//  Created by Cris Messias on 28/09/23.
//

import SwiftUI


struct AvatarView: View {

    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .cornerRadius(100 / 2)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 100, height: 100)
            )
            .shadow(radius: 10)
    }
}


struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView()
    }
}
