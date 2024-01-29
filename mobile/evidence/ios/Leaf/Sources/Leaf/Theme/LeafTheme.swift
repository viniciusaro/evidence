import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let font: TextColors
        public let button: ButtonColors
        public let warning: WarningColors
        public let system: SystemColors
        public let custom: CustomThemeColors
    }

    public struct TextColors {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let tertiary: SwiftUI.Color
        public let link: SwiftUI.Color
    }

    public struct ButtonColors {
        public let buttonPrimary: SwiftUI.Color
        public let buttonSecondary: SwiftUI.Color
        public let buttonGoogle: SwiftUI.Color
    }

    public struct WarningColors {
        public let success: SwiftUI.Color
        public let alert: SwiftUI.Color
        public let error: SwiftUI.Color
        public let errorBG: SwiftUI.Color
    }

    public struct SystemColors {
        public let aubergineBG: SwiftUI.Color
        public let avatarActive: SwiftUI.Color
        public let avatarAway: SwiftUI.Color
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

