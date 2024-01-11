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
        system: LeafTheme.SystemColors(
            primary: Color(red: 29/255, green: 28/255, blue: 29/255),
            secondary: Color(red: 134/255, green: 134/255, blue: 134/255),
            link: Color(red: 54/255, green: 197/255, blue: 240/255),
            successGreen: Color(red: 46/255, green: 182/255, blue: 125/255),
            successBlue: Color(red: 14/255, green: 157/255, blue: 211/255),
            alert: Color(red: 236/255, green: 178/255, blue: 46/255),
            error: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        custom: LeafTheme.CustomThemeColors(
            topBar: Color(red: 74/255, green: 21/255, blue: 75/255),
            floatButton: Color(red: 74/255, green: 21/255, blue: 75/255)
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
        system: LeafTheme.SystemColors(
            primary: Color(red: 255/255, green: 255/255, blue: 255/255),
            secondary: Color(red: 244/255, green: 237/255, blue: 228/255),
            link: Color(red: 54/255, green: 197/255, blue: 240/255),
            successGreen: Color(red: 46/255, green: 182/255, blue: 125/255),
            successBlue: Color(red: 14/255, green: 157/255, blue: 211/255),
            alert: Color(red: 236/255, green: 178/255, blue: 46/255),
            error: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        custom: LeafTheme.CustomThemeColors(
            topBar: Color(red: 74/255, green: 21/255, blue: 75/255),
            floatButton: Color(red: 74/255, green: 21/255, blue: 75/255)
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
