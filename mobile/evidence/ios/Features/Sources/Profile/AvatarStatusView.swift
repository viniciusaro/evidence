//
//  AvatarStatusView.swift
//  Evidence
//
//  Created by Cris Messias on 09/11/23.
//

import SwiftUI
import Leaf

public struct AvatarStatusView: View {
    @ObservedObject var model: StatusViewModel
    @Environment(\.leafTheme) private var theme

    public init(model: StatusViewModel) {
        self.model = model
    }

    public var body: some View {
        HStack {
            ZStack(alignment: .bottomTrailing) {
                LeafAvatar(url: URL.documentsDirectory)
                    .avatarStyle(.evident)
                Circle()
                    .foregroundStyle(model.currentState == .active ? theme.color.brand.primary : theme.color.content.tertiary )
                    .frame(width: 15, height: 15)
                    .overlay {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    }
            }
            VStack (alignment: .leading) {
                Text("Cris Messias")
                    .title()
                Text("\(model.currentState == .active ? "Active": "Away")")
                    .subtitle()
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
    }
}    

#Preview {
    AvatarStatusView(model: StatusViewModel())
}
