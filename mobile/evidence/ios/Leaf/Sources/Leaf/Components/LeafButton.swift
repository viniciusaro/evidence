import SwiftUI

public struct LeafPrimaryButton: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeafPrimaryButtonStyle(configuration: configuration)
    }
}

private struct LeafPrimaryButtonStyle: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafPrimaryButton.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(.white)
            .subtitle()
            .background(theme.color.system.buttonPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}


public struct LeafSecondaryButton: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeafSecondaryButtonStyle(configuration: configuration)
    }
}

private struct LeafSecondaryButtonStyle: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafSecondaryButton.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.brand.aubergine)
            .subtitle()
            .background(theme.color.font.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}
public struct LeafGoogleLoginButton: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeafGoogleLoginButtonStyle(configuration: configuration)
    }
}

private struct LeafGoogleLoginButtonStyle: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafGoogleLoginButton.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(.white)
            .subtitle()
            .background(theme.color.brand.blueGoogle)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}


#Preview {
    VStack {
        LeafThemeView {
            Button("Getting started") {

            }
            .buttonStyle(LeafGoogleLoginButton())

        }
        .padding(20)
        .background(.green)
        .previewCustomFonts()
    }

}
