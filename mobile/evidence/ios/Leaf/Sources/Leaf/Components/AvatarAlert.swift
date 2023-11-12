//
//  AvatarAlert.swift
//  
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI

public struct AvatarAlert: View {
    var image: String
    var text: String
    @Environment(\.leafTheme) private var theme
    
    public init(image: String, text: String) {
        self.image = image
        self.text = text
    }
    
    public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color.black.opacity(0.7))
                    .frame(width: 170, height: 150)
                VStack {
                    Image(systemName: image)
                        .font(.system(size: 56, weight: .semibold))
                        .padding(8)
                    Text(text)
                }
                .foregroundStyle(.white)
            }
        }
    }

#Preview {
    AvatarAlert(image: "checkmark", text: "Status Saved")
}
