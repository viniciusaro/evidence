import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let text: TextColors
        public let button: ButtonColors
        public let warning: WarningColors
        public let backgrond: BackgroundColors
        public let state: StateColors
        public let custom: CustomThemeColors
    }

    public struct TextColors {
        public let primary: SwiftUI.Color
        public let primaryOnBackground: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let tertiaryLight: SwiftUI.Color
        public let link: SwiftUI.Color
    }

    public struct ButtonColors {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let authGoogle: SwiftUI.Color
    }

    public struct WarningColors {
        public let success: SwiftUI.Color
        public let alert: SwiftUI.Color
        public let error: SwiftUI.Color
    }

    public struct BackgroundColors {
        public let aubergine: SwiftUI.Color
        public let red: SwiftUI.Color
        public let dark: SwiftUI.Color
        public let background: SwiftUI.Color
        public let container: SwiftUI.Color
    }

    public struct StateColors {
        public let active: SwiftUI.Color
        public let disabled: SwiftUI.Color
    }

    public struct CustomThemeColors {
        public let topBar: SwiftUI.Color
        public let floatButton: SwiftUI.Color
    }
}

extension LeafTheme {
    public struct Size {
        public let lineSpacingTitle: SwiftUI.CGFloat
    }
}

