//
//  LeafPopup.swift
//
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI

public struct LeafPopup: View {
    var state: PopupState
    @Environment(\.leafTheme) private var theme
    
    public init(state: PopupState) {
        self.state = state
    }
    
    public var body: some View {
        VStack {
            switch state {
            case .save:
                PopupView(image: "checkmark", text: "Set Status")
            case .clear:
                PopupView(image: "checkmark", text: "Status Cleared")
            }
        }
    }
}

public enum PopupState {
    case save, clear
}

struct PopupView: View {
    @Environment(\.leafTheme) private var theme
    private var image: String
    private var text: String
    
    init(image: String, text: String) {
        self.image = image
        self.text = text
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(theme.color.text.primary)
                .opacity(0.7)
            VStack {
                Image(systemName: image)
                    .font(.system(size: 56, weight: .semibold))
                    .padding(8)
                Text(text)
//                    .font(.bodyLeaf)
                    .body()
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LeafPopup(state: .save)
        .previewCustomFonts()
}
