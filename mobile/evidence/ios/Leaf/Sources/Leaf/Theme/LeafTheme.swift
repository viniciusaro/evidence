import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let font: Font
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let brand: BrandColor
        public let content: ContentColor
    }
    
    public struct BrandColor {
        let primary: SwiftUI.Color
        let secondary: SwiftUI.Color
        let tertiary: SwiftUI.Color
    }
    
    public struct ContentColor {
        let primary: SwiftUI.Color
        let secondary: SwiftUI.Color
        let tertiary: SwiftUI.Color
        let quaternary: SwiftUI.Color
    }
}

extension LeafTheme {
    public struct Font {
        let title: SwiftUI.Font
        let titleLarge: SwiftUI.Font
        let titleXLarge: SwiftUI.Font
        let subtitle: SwiftUI.Font
        let body: SwiftUI.Font
        let label: SwiftUI.Font
    }
}

extension LeafTheme {
    public struct Size {
        let lineSpacingTitle: SwiftUI.CGFloat
    }
}
