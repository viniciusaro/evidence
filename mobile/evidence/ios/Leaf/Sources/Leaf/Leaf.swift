import SwiftUI

public struct LeafView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Vinão")
        }
        .padding()
    }
}
