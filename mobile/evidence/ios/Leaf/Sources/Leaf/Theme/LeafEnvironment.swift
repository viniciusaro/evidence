import SwiftUI

private struct LeafThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: LeafTheme = defaultLeafTheme
}

extension EnvironmentValues {
    public var leafTheme: LeafTheme {
        get { self[LeafThemeEnvironmentKey.self] }
        set { self[LeafThemeEnvironmentKey.self] = newValue }
    }
}

public let defaultLeafTheme = LeafTheme(
    color: LeafTheme.Color(
        brand: LeafTheme.BrandColor(
            primary: .green,
            secondary: Color(red: 104/255, green: 93/255, blue: 67/255),
            tertiary: .black
        ),
        content: LeafTheme.ContentColor(
            primary: .black,
            secondary: .gray,
            tertiary: .green
        )
    ),
    font: LeafTheme.Font(
        title: .title2,
        titleLarge: .title,
        titleXLarge: .largeTitle,
        body: .body,
        label: .caption
    )
)

public let darkLeafTheme = LeafTheme(
    color: LeafTheme.Color(
        brand: LeafTheme.BrandColor(
            primary: .blue,
            secondary: Color(red: 104/255, green: 93/255, blue: 67/255),
            tertiary: .black
        ),
        content: LeafTheme.ContentColor(
            primary: .black,
            secondary: .gray,
            tertiary: .green
        )
    ),
    font: LeafTheme.Font(
        title: .title2,
        titleLarge: .title,
        titleXLarge: .largeTitle,
        body: .body,
        label: .caption
    )
)
