//
//  LeafTag.swift
//  
//
//  Created by Cris Messias on 15/10/23.
//

import SwiftUI

public struct LeafTag: View {
    private let text: String
    private let status: StatusTag
    
    public init(_ text: String, status: StatusTag) {
        self.text = text
        self.status = status
    }
    
    @Environment(\.leafTheme) private var theme
    
    public var body: some View {
        VStack {
            switch status {
            case .open:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.warning.success)
                    .background(theme.color.warning.success.opacity(0.1))
            case .accepted:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.warning.alert)
                    .background(theme.color.warning.alert.opacity(0.1))
            case .rejected:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.warning.error)
                    .background(theme.color.warning.error.opacity(0.1))
            case .closed:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.text.secondary)
                    .background(theme.color.text.secondary.opacity(0.1))
            }
        }
        .cornerRadius(20)
    }
}

///
public enum StatusTag {
    case open, accepted, rejected, closed
}

///
extension Text {
    func tagStyle() -> some View {
        self
            .textCase(.uppercase)
            .font(.custom("Lato-Bold", size: 12))
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
    }
}

#Preview {
    VStack{
        LeafTag("open", status: .open)
        LeafTag("accepted", status: .accepted)
        LeafTag("rejected", status: .rejected)
        LeafTag("closed", status: .closed)
    }
}
