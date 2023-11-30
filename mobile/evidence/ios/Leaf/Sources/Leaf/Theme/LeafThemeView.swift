import SwiftUI

public struct LeafThemeView<C: View>: View {
    @Environment(\.colorScheme) var colorScheme
    private let childView: C
    
    public init (_ childView: () -> (C)) {
        self.childView = childView()
    }
    
    private var theme: LeafTheme {
        colorScheme == .light ? defaultLeafTheme : darkLeafTheme
    }
    
    public var body: some View {
        childView
            .environment(\.leafTheme, theme)
            .tint(theme.color.core.aubergine)
    }
}
