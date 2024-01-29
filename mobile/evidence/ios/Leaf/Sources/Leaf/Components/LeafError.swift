//
//  LeafError.swift
//
//
//  Created by Cris Messias on 25/01/24.
//

import SwiftUI

public struct LeafError: View {
    @Environment(\.leafTheme) private var theme
    var message: String

    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(theme.color.warning.error)
                .title()
            Text(message)
                .label()
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 8))
        .frame(maxWidth: .infinity)
        .background(theme.color.backgrond.red)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

#Preview {
    LeafError(message: "No email provided.")
        .padding(16)
        .previewCustomFonts()
}
