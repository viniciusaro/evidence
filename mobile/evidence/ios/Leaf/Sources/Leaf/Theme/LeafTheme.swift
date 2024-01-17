import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let font: FontColors
        public let system: SystemColors
        public let custom: CustomThemeColors
    }

    public struct FontColors {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let link: SwiftUI.Color
    }

    public struct SystemColors {
        public let buttonPrimary: SwiftUI.Color
        public let avatarActive: SwiftUI.Color
        public let success: SwiftUI.Color
        public let alert: SwiftUI.Color
        public let error: SwiftUI.Color
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

