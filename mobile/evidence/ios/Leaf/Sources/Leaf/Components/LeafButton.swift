import SwiftUI

public struct LeafPrimaryButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        LeafPrimaryButton(configuration: configuration)
    }
}

private struct LeafPrimaryButton: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafPrimaryButtonStyle.Configuration
    
    var body: some View {
        configuration
            .label
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.button.buttonPrimary)
            .buttonBorderShape(.roundedRectangle)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(theme.color.button.buttonPrimary, lineWidth: 2)
            }
    }
}

#Preview {
    LeafThemeView {
        Button("Evidence") {
            
        }
        .buttonStyle(LeafPrimaryButtonStyle())
        .previewCustomFonts()
    }
}
