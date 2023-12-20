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
            .font(theme.font.titleLarge)
            .bold()
            .lineSpacing(theme.size.lineSpacingTitle)
            .foregroundStyle(theme.color.core.black)

    }
}
public extension Text {
    func title() -> some View {
        self.modifier(LeafTitleModifier())
    }
}

//MARK: - SubtitleModifier
public struct LeafSubtitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.subtitle)
            .bold()
            .foregroundStyle(theme.color.core.black)

    }
}
public extension Text {
    func subtitle() -> some View {
        self.modifier(LeafSubtitleModifier())
    }
}

//MARK: - BodyModifier
public struct LeafBodyModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.body)
            .foregroundStyle(theme.color.core.black)
    }
}
public extension Text {
    func body() -> some View {
        self.modifier(LeafBodyModifier())
    }
}

//MARK: - LabelModifier
public struct LeafLabelModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.label)
            .bold()
            .foregroundStyle(theme.color.gray.primary50)
    }
}
public extension Text {
    func label() -> some View {
        self.modifier(LeafLabelModifier())
    }
}

#Preview {
    LeafThemeView {
        VStack(alignment: .leading) {
            Text("Secondary palette20")
                .title()
            Text("Usage")
                .subtitle()
            Text("We give our core palette more dimension with a set of vibrant, sophisticated colors heavily featured in our photography and illustration.")
                .body()
            Text("1 like")
                .label()
        }
        .padding(20)
    }
}
