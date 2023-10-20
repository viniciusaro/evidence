//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 15/10/23.
//

import SwiftUI

struct LeafTag: View {
    private let text: String
    private let status: StatusTag
    
    init(_ text: String, status: StatusTag) {
        self.text = text
        self.status = status
    }
    
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        VStack {
            switch status {
            case .open:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.tag.open)
                    .background(theme.color.tag.open.opacity(0.1))
            case .accepted:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.tag.accepted)
                    .background(theme.color.tag.accepted.opacity(0.1))
            case .rejected:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.tag.rejected)
                    .background(theme.color.tag.rejected.opacity(0.1))
            case .closed:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.tag.closed)
                    .background(theme.color.tag.closed.opacity(0.1))
            }
        }
        .cornerRadius(20)
    }
}

///
enum StatusTag {
    case open, accepted, rejected, closed
}

///
extension Text {
    func tagStyle() -> some View {
        self
            .textCase(.uppercase)
            .font(.callout)
            .bold()
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}

///
#Preview {
    VStack{
        LeafTag("open", status: .open)
        LeafTag("accepted", status: .accepted)
        LeafTag("rejected", status: .rejected)
        LeafTag("closed", status: .closed)
    }
}
