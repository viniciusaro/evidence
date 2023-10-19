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
        ),
        auxiliar: LeafTheme.AuxiliarColor(
            auxiliar: Color(red:3/255, green: 129/255, blue: 220/255),
            success: .green,
            error: Color(red:249/255, green: 100/255, blue: 90/255),
            disabled: Color(red:121/255, green: 128/255, blue: 117/255)
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
        ),
        auxiliar: LeafTheme.AuxiliarColor(
            auxiliar: Color(red:74/255, green: 179/255, blue: 255/255),
            success:  Color(red:68/255, green: 177/255, blue: 16/255),
            error: Color(red:249/255, green: 100/255, blue: 90/255),
            disabled: Color(red:162/255, green: 168/255, blue: 159/255)
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

