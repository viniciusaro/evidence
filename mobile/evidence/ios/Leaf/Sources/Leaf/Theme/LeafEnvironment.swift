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
        core: LeafTheme.CorePallette(
            aubergine: Color(red: 74/255, green: 21/255, blue: 75/255),
            horchata: Color(red: 244/255, green: 237/255, blue: 228/255),
            black: Color(red: 29/255, green: 28/255, blue: 29/255),
            white: Color(red: 255/255, green: 255/255, blue: 255/255),
            blue: Color(red: 54/255, green: 197/255, blue: 240/255),
            green: Color(red: 46/255, green: 182/255, blue: 125/255),
            yellow: Color(red: 236/255, green: 178/255, blue: 46/255),
            red: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        secondary: LeafTheme.SecondaryPallette(
            cobalt: Color(red: 30/255, green: 50/255, blue: 143/255),
            sky: Color(red: 14/255, green: 157/255, blue: 211/255),
            teal: Color(red: 35/255, green: 146/255, blue: 162/255),
            pool: Color(red: 120/255, green: 215/255, blue: 221/255),
            evergreen: Color(red: 24/255, green: 95/255, blue: 52/255),
            moss: Color(red: 114/255, green: 156/255, blue: 26/255),
            sandbar: Color(red: 255/255, green: 213/255, blue: 126/255),
            peach: Color(red: 254/255, green: 212/255, blue: 190/255),
            salmon: Color(red: 242/255, green: 96/255, blue: 106/255),
            bubblegum: Color(red: 225/255, green: 182/255, blue: 189/255),
            crimson: Color(red: 146/255, green: 29/255, blue: 33/255),
            terracota: Color(red: 222/255, green: 137/255, blue: 105/255),
            berry: Color(red: 124/255, green: 40/255, blue: 82/255),
            mauve: Color(red: 192/255, green: 91/255, blue: 140/255)
        ),
        gray: LeafTheme.GrayPallette(
            primary70: Color(red: 97/255, green: 96/255, blue: 97/255),
            primary50: Color(red: 134/255, green: 134/255, blue: 134/255),
            primary13: Color(red: 221/255, green: 221/255, blue: 221/255),
            primary4: Color(red: 248/255, green: 248/255, blue: 248/255)
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
        core: LeafTheme.CorePallette(
            aubergine: Color(red: 74/255, green: 21/255, blue: 75/255),
            horchata: Color(red: 244/255, green: 237/255, blue: 228/255),
            black: Color(red: 209/255, green: 210/255, blue: 211/255), //done
            white: Color(red: 28/255, green: 29/255, blue: 33/255), //done
            blue: Color(red: 54/255, green: 197/255, blue: 240/255),
            green: Color(red: 46/255, green: 182/255, blue: 125/255),
            yellow: Color(red: 236/255, green: 178/255, blue: 46/255),
            red: Color(red: 224/255, green: 30/255, blue: 90/255)
        ),
        secondary: LeafTheme.SecondaryPallette(
            cobalt: Color(red: 30/255, green: 50/255, blue: 143/255),
            sky: Color(red: 14/255, green: 157/255, blue: 211/255),
            teal: Color(red: 35/255, green: 146/255, blue: 162/255),
            pool: Color(red: 120/255, green: 215/255, blue: 221/255),
            evergreen: Color(red: 24/255, green: 95/255, blue: 52/255),
            moss: Color(red: 114/255, green: 156/255, blue: 26/255),
            sandbar: Color(red: 255/255, green: 213/255, blue: 126/255),
            peach: Color(red: 254/255, green: 212/255, blue: 190/255),
            salmon: Color(red: 242/255, green: 96/255, blue: 106/255),
            bubblegum: Color(red: 225/255, green: 182/255, blue: 189/255),
            crimson: Color(red: 146/255, green: 29/255, blue: 33/255),
            terracota: Color(red: 222/255, green: 137/255, blue: 105/255),
            berry: Color(red: 124/255, green: 40/255, blue: 82/255),
            mauve: Color(red: 192/255, green: 91/255, blue: 140/255)
        ),
        gray: LeafTheme.GrayPallette( //all done
            primary70: Color(red: 154/255, green: 156/255, blue: 158/255),
            primary50: Color(red: 117/255, green: 119/255, blue: 122/255),
            primary13: Color(red: 50/255, green: 53/255, blue: 56/255),
            primary4: Color(red: 33/255, green: 36/255, blue: 40/255)
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


