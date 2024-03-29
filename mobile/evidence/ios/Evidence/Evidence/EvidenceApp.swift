//
//  EvidenceApp.swift
//  Evidence
//
//  Created by Vinicius Alves Rodrigues on 26/09/23.
//

import SwiftUI
import Leaf

@main
struct EvidenceApp: App {
    init() {
        CustomFonts.registerCustomFonts()
    }
    var body: some Scene {
        WindowGroup {
            LeafThemeView {
                ContentView()
            }
        }
    }
}
