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
                    .foregroundStyle(model.status == .active ? theme.color.core.green : theme.color.gray.primary50 )
                    .frame(width: 15, height: 15)
                    .overlay {
                        Circle()
                            .stroke(theme.color.core.white, lineWidth: 3)
                    }
            }
            VStack (alignment: .leading) {
                Text("Cris Messias")
                    .font(.title)
                    .bold()
                    .foregroundStyle(theme.color.core.black)
                    
                Text("\(model.status == .active ? "Active": "Away")")
                    .font(.headline)
                    .foregroundStyle(theme.color.gray.primary50)
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
