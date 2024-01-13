import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let system: SystemColors
        public let custom: CustomThemeColors
    }

    public struct SystemColors {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let link: SwiftUI.Color
        public let successGreen: SwiftUI.Color
        public let successBlue: SwiftUI.Color
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

