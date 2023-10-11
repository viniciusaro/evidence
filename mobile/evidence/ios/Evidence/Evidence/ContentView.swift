//
//  ContentView.swift
//  Evidence
//
//  Created by Vinicius Alves Rodrigues on 26/09/23.
//

import SwiftUI
import Leaf

struct ContentView: View {
    var body: some View {
            VStack(alignment: .leading) {
                VStack(alignment:.leading) {
                    Text("kstewart")
                        .subtitleModifier()
                        .padding(.bottom, 1)
                    Text("76 answers - 100 views")
                        .labelModifier()
                        .padding(.bottom)
                }
                Text("If you were to start over, would you choose SwiftUI or UIKit? ")
                    .titleModifier()
                    .padding(.bottom)
                Text("SwiftUI. All of our new development is in SwiftUI. We’re also taking time to rewrite components and screens in SwiftUI as time allows. It’s just more maintainable at this point. And this is coming from someone starting with Objective-C / nib files / hand layout through storyboards / autolayout, etc.")
                    .bodyModifier()
                    .padding(.bottom)
                Text("13 likes - 76 comments - 100 votes")
                    .labelModifier()
                    .padding(.bottom)
                Button("Evidence") {
                    
                }.buttonStyle(LeafPrimaryButtonStyle())
                
            }
            .padding(.horizontal, 16)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
