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
            secondary: Color(red:72/255, green: 72/255, blue: 74/255),
            tertiary: .gray,
            quaternary: .green
        )
    ),
    font: LeafTheme.Font(
        title: .title2,
        titleLarge: .title,
        titleXLarge: .largeTitle,
        subtitle: .headline,
        body: .body,
        label: .caption
    ), 
    size: LeafTheme.Size(
        lineSpacingTitle: 0.2

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
            primary: .white,
            secondary: .gray,
            tertiary: .gray,
            quaternary: .green
        )
    ),
    font: LeafTheme.Font(
        title: .title2,
        titleLarge: .title,
        titleXLarge: .largeTitle,
        subtitle: .headline,
        body: .body,
        label: .caption
    ), 
    size: LeafTheme.Size(
        lineSpacingTitle: 0.2
    )
)

