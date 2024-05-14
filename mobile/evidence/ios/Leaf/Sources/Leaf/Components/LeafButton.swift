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
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.text.tertiaryLight)
            .subtitle()
            .background(theme.color.button.primary)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}


public struct LeafSecondaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeafSecondaryButton(configuration: configuration)
    }
}

private struct LeafSecondaryButton: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafSecondaryButtonStyle.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.backgrond.aubergine)
            .subtitle()
            .background(theme.color.text.tertiaryLight)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

public struct LeafGoogleLoginButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeafGoogleLoginButton(configuration: configuration)
    }
}

private struct LeafGoogleLoginButton: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafGoogleLoginButtonStyle.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.text.tertiaryLight)
            .subtitle()
            .background(theme.color.button.authGoogle)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

public struct LeaflinkButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        LeaflinkButton(configuration: configuration)
    }
}

private struct LeaflinkButton: View {
    @Environment(\.leafTheme) private var theme
    let configuration: LeafGoogleLoginButtonStyle.Configuration

    var body: some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            .foregroundColor(theme.color.text.secondary)
            .subtitle()
    }
}


#Preview {
    VStack {
        LeafThemeView {
            Button("Reset password") {

            }
            .buttonStyle(LeaflinkButtonStyle())

        }
        .padding(20)
//        .background(.green)
        .previewCustomFonts()
    }

}
