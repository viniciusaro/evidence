//
//  File.swift
//  
//
//  Created by Cris Messias on 29/01/24.
//

import SwiftUI

public struct LeafImageLogin: View {
    public init() {}
    public var body: some View {
        Image("login", bundle: .module)
            .resizable()
            .scaledToFit()
            .padding(.leading, 28)
    }
}

public struct LeafImageLoginCheckEmail: View {
    public init() {}
    public var body: some View {
        Image("loginCheckEmail", bundle: .module)
            .resizable()
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaledToFit()
            .padding(.top, 24)
    }
}


#Preview {
    VStack {
        LeafImageLoginCheckEmail()
        LeafImageLogin()
    }
}
