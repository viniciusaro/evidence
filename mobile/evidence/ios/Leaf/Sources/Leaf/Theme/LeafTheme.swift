import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let font: Font
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
    }
}

extension LeafTheme {
    public struct Font {
        let title: SwiftUI.Font
        let titleLarge: SwiftUI.Font
        let titleXLarge: SwiftUI.Font
        let body: SwiftUI.Font
        let label: SwiftUI.Font
    }
}
