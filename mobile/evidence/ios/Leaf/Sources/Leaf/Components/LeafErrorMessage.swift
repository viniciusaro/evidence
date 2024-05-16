//
//  LeafError.swift
//
//
//  Created by Cris Messias on 25/01/24.
//

import SwiftUI

public struct LeafErrorMessage: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        MessageStyle(
            message: message,
            background: theme.color.backgrond.red,
            iconColor: theme.color.warning.error
        )
    }
}

public struct LeafSuccessMessage: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        MessageStyle(
            message: message,
            background: theme.color.backgrond.blue,
            iconColor: theme.color.warning.success
        )
    }
}

public struct LeafAlertMessage: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        MessageStyle(
            message: message,
            background: theme.color.backgrond.yellow,
            iconColor: theme.color.warning.alert
        )
    }
}

public struct MessageStyle: View {
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
        LeafErrorMessage(message: "No email provided.")
        LeafSuccessMessage(message: "You are connected!")
        LeafAlertMessage(message: "Your connection is slow.")
    }
    .padding(16)
    .previewCustomFonts()
}
