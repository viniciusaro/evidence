import ComposableArchitecture
import ChatKit
import FirebaseCore
import SwiftUI
import Leaf

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct EvidenceLabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        CustomFonts.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            LeafThemeView {
                RootView(
                    store: Store(initialState: RootFeature.State()) {
                        RootFeature()
                    }
                )
            }
        }
    }
}
