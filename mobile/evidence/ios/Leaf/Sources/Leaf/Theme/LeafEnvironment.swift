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
        text: LeafTheme.TextColors(
            primary: Color(red: 29/255, green: 28/255, blue: 29/255),
            secondary: Color(red: 29/255, green: 28/255, blue: 29/255, opacity: 0.7),
            tertiaryLight: Color(red: 255/255, green: 255/255, blue: 255/255),
            link: Color(red: 18/255, green: 100/255, blue: 163/255)
        ),
        button: LeafTheme.ButtonColors(
            primary: Color(red: 0/255, green: 122/255, blue: 90/255),
            secondary: Color(red: 255/255, green: 255/255, blue: 255/255),
            authGoogle: Color(red: 72/255, green: 132/255, blue: 244/255)
        ),
        warning: LeafTheme.WarningColors(
            success: Color(red: 18/255, green: 100/255, blue: 163/255),
            alert: Color(red: 236/255, green: 178/255, blue: 46/255),
            error: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        backgrond: LeafTheme.BackgroundColors(
            aubergine: Color(red: 74/255, green: 21/255, blue: 75/255), 
            red: Color(red: 224/255, green: 30/255, blue: 90/255, opacity: 0.1)
        ),
        state: LeafTheme.StateColors(
            active: Color(red: 29/255, green: 28/255, blue: 29/255, opacity: 0.4),
            disabled: Color(red: 46/255, green: 182/255, blue: 125/255)
        ),
        custom: LeafTheme.CustomThemeColors(
            topBar: Color(red: 74/255, green: 21/255, blue: 75/255),
            floatButton: Color(red: 74/255, green: 21/255, blue: 75/255)
        )
    ),
    size: LeafTheme.Size(
        lineSpacingTitle: 0.2
    )
)

public let darkLeafTheme = LeafTheme(
    color: LeafTheme.Color(
        text: LeafTheme.TextColors(
            primary: Color(red: 255/255, green: 255/255, blue: 255/255),
            secondary: Color(red: 244/255, green: 237/255, blue: 228/255),
            tertiaryLight: Color(red: 255/255, green: 255/255, blue: 255/255),
            link: Color(red: 18/255, green: 100/255, blue: 163/255)
        ),
        button: LeafTheme.ButtonColors(
            primary: Color(red: 0/255, green: 122/255, blue: 90/255),
            secondary: Color(red: 255/255, green: 255/255, blue: 255/255),
            authGoogle: Color(red: 72/255, green: 132/255, blue: 244/255)
        ),
        warning: LeafTheme.WarningColors(
            success: Color(red: 18/255, green: 100/255, blue: 163/255),
            alert: Color(red: 236/255, green: 178/255, blue: 46/255),
            error: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        backgrond: LeafTheme.BackgroundColors(
            aubergine: Color(red: 74/255, green: 21/255, blue: 75/255),
            red: Color(red: 224/255, green: 30/255, blue: 90/255, opacity: 0.1)
        ),
        state: LeafTheme.StateColors(
            active: Color(red: 244/255, green: 237/255, blue: 228/255, opacity: 0.5),
            disabled: Color(red: 46/255, green: 182/255, blue: 125/255)
        ),
        custom: LeafTheme.CustomThemeColors(
            topBar: Color(red: 74/255, green: 21/255, blue: 75/255),
            floatButton: Color(red: 74/255, green: 21/255, blue: 75/255)
        )
    ),
    size: LeafTheme.Size(
        lineSpacingTitle: 0.2
    )
)
