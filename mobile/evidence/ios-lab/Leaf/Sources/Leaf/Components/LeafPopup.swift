//
//  LeaAlert.swift
//
//
//  Created by Cris Messias on 12/11/23.
//

import SwiftUI

public struct LeaAlert: View {
    var state: AlertState
    @Environment(\.leafTheme) private var theme

    public init(state: AlertState) {
        self.state = state
    }

    public var body: some View {
        VStack {
            switch state {
            case .save:
                AlertView(image: "checkmark", text: "Set Status")
            case .clear:
                AlertView(image: "checkmark", text: "Status Cleared")
            case .confirmation:
                AlertView(image: "paperplane", text: "Password Reset Sent")
            }
        }
    }
}

public enum AlertState {
    case save, clear, confirmation
}

struct AlertView: View {
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
    LeaAlert(state: .confirmation)
        .previewCustomFonts()
}
