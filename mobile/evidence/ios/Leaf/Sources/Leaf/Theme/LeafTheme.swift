import SwiftUI

public struct LeafTheme {
    public let color: Color
    public let font: Font
    public let size: Size
}

extension LeafTheme {
    public struct Color {
        public let core: CorePallette
        public let secondary: SecondaryPallette
        public let gray: GrayPallette
    }
    
    public struct CorePallette {
        public let aubergine: SwiftUI.Color
        public let horchata: SwiftUI.Color
        public let black: SwiftUI.Color
        public let white: SwiftUI.Color
        public let blue: SwiftUI.Color
        public let green: SwiftUI.Color
        public let yellow: SwiftUI.Color
        public let red: SwiftUI.Color
    }
    
    public struct SecondaryPallette {
        public let cobalt: SwiftUI.Color
        public let sky: SwiftUI.Color
        public let teal: SwiftUI.Color
        public let pool: SwiftUI.Color
        public let evergreen: SwiftUI.Color
        public let moss: SwiftUI.Color
        public let sandbar: SwiftUI.Color
        public let peach: SwiftUI.Color
        public let salmon: SwiftUI.Color
        public let bubblegum: SwiftUI.Color
        public let crimson: SwiftUI.Color
        public let terracota: SwiftUI.Color
        public let berry: SwiftUI.Color
        public let mauve: SwiftUI.Color
    }
    
    public struct GrayPallette {
        public let primary70: SwiftUI.Color
        public let primary50: SwiftUI.Color
        public let primary13: SwiftUI.Color
        public let primary4: SwiftUI.Color
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
