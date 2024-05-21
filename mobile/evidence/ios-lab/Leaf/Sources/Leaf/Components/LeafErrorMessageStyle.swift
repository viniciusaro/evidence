//
//  LeafError.swift
//
//
//  Created by Cris Messias on 25/01/24.
//

import SwiftUI

public struct LeafErrorMessageStyle: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        Message(
            message: message,
            background: theme.color.backgrond.red,
            iconColor: theme.color.warning.error
        )
    }
}

public struct LeafSuccessMessageStyle: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Message(
            message: message,
            background: theme.color.backgrond.blue,
            iconColor: theme.color.warning.success
        )
    }
}

public struct LeafAlertMessageStyle: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Message(
            message: message,
            background: theme.color.backgrond.yellow,
            iconColor: theme.color.warning.alert
        )
    }
}

private struct Message: View {
    @Environment(\.leafTheme) private var theme
    let message: String
    let background: Color
    let iconColor: Color

    public var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(iconColor)
                .title()
            Text(message)
                .label()
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 8))
        .frame(maxWidth: .infinity)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}


#Preview {
    VStack {
        LeafErrorMessageStyle(message: "No email provided.")
        LeafSuccessMessageStyle(message: "You are connected!")
        LeafAlertMessageStyle(message: "Your connection is slow.")
    }
    .padding(16)
    .previewCustomFonts()
}
