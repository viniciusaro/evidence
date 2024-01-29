//
//  LeafText.swift
//  
//
//  Created by Cris Messias on 06/10/23.
//

import SwiftUI



//MARK: -TitleModifier
public struct LeafTitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Black", size: 20))
            .foregroundStyle(theme.color.text.primary)

    }
}
public extension View {
    func title() -> some View {
        self.modifier(LeafTitleModifier())
    }
}

//MARK: - SubtitleModifier
public struct LeafSubtitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Regular", size: 17))
            .foregroundStyle(theme.color.text.secondary)

    }
}
public extension View {
    func subtitle() -> some View {
        self.modifier(LeafSubtitleModifier())
    }
}

//MARK: - BodyModifier
public struct LeafBodyModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Regular", size: 17))
            .foregroundStyle(theme.color.text.primary)
    }
}
public extension View {
    func body() -> some View {
        self.modifier(LeafBodyModifier())
    }
}

//MARK: - LinkModifier
public struct LeafLinkModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Bold", size: 17))
            .bold()
            .foregroundStyle(theme.color.text.link)
    }
}

public extension View {
    func link() -> some View {
        self.modifier(LeafLinkModifier())
    }
}

//MARK: - LabelModifier
public struct LeafLabelModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(.custom("Lato-Light", size: 14))
            .foregroundStyle(theme.color.text.secondary)
    }
}
public extension View {
    func label() -> some View {
        self.modifier(LeafLabelModifier())
    }
}


#Preview {
    LeafThemeView {
        VStack(alignment: .leading) {
            Text("Cris Messias")
                .title()
            Text("Away")
                .subtitle()
                .padding(.bottom, 12)
            Text("I am not crazy! I am freeeeeee!")
                .body()
            Text("I am not crazy! I am freeeeeee!")
                .link()
            Text("1 hours ago")
                .label()
        }
    }
    .previewCustomFonts()
}
