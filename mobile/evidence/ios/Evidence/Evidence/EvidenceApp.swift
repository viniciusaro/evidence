//
//  EvidenceApp.swift
//  Evidence
//
//  Created by Vinicius Alves Rodrigues on 26/09/23.
//

import SwiftUI
import Leaf
import FirebaseCore

@main
struct EvidenceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
