//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 15/10/23.
//

import SwiftUI

struct LeafTag: View {
    private let text: String
    private var status: StatusTag
    
    init(_ text: String, status: StatusTag) {
        self.text = text
        self.status = status
    }
    
    @Environment(\.leafTheme) private var theme
    
    var body: some View {
        VStack {
            switch status {
            case .auxiliar:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.auxiliar.auxiliar)
                    .background(theme.color.auxiliar.auxiliar.opacity(0.1))
            case .disabled:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.auxiliar.disabled)
                    .background(theme.color.auxiliar.disabled.opacity(0.1))
            case .success:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.auxiliar.success)
                    .background(theme.color.auxiliar.success.opacity(0.1))
            case .error:
                Text(text)
                    .tagStyle()
                    .foregroundColor(theme.color.auxiliar.error)
                    .background(theme.color.auxiliar.error.opacity(0.1))
            }
        }
        .cornerRadius(20)
    }
}

#Preview(body: {
    VStack{
        LeafTag("open", status: .auxiliar)
        LeafTag("accepted", status: .success)
        LeafTag("rejected", status: .error)
        LeafTag("closed", status: .disabled)
    }
})


///
enum StatusTag: CaseIterable {
    case success, error, auxiliar, disabled
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
