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
            case .confirmation:
                PopupView(image: "paperplane", text: "Password Reset Sent")
            }
        }
    }
}

public enum PopupState {
    case save, clear, confirmation
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
                .foregroundStyle(theme.color.backgrond.dark)
                .opacity(0.9)
            VStack {
                Image(systemName: image)
                    .font(.system(size: 56, weight: .semibold))
                    .padding(8)
                Text(text)
                    .foregroundStyle(theme.color.text.tertiaryLight)
                    .body()
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LeafPopup(state: .confirmation)
        .previewCustomFonts()
}
