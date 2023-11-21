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
        public let tag: TagColor
    }
    
    public struct BrandColor {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let tertiary: SwiftUI.Color
    }
    
    public struct ContentColor {
        public let primary: SwiftUI.Color
        public let secondary: SwiftUI.Color
        public let tertiary: SwiftUI.Color
        public let quaternary: SwiftUI.Color
    }
    
    public struct TagColor {
        public let open: SwiftUI.Color
        public let accepted: SwiftUI.Color
        public let rejected: SwiftUI.Color
        public let closed: SwiftUI.Color
    }
}

extension LeafTheme {
    public struct Font {
        public let title: SwiftUI.Font
        public let titleLarge: SwiftUI.Font
        public let titleXLarge: SwiftUI.Font
        public let subtitle: SwiftUI.Font
        public let body: SwiftUI.Font
        public let label: SwiftUI.Font
    }
}

extension LeafTheme {
    public struct Size {
        public let lineSpacingTitle: SwiftUI.CGFloat
    }
}
