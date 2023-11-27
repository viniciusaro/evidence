//
//  LeafPopup.swift
//
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI

public struct LeafPopup: View {
    var text: String
    @Environment(\.leafTheme) private var theme
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color.black)
                .opacity(0.7)
            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 56, weight: .semibold))
                    .padding(8)
                Text(text)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LeafPopup(text: "Status Cleared")
}
