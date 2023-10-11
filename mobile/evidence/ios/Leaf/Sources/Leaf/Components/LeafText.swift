//
//  LeafText.swift
//  
//
//  Created by Cris Messias on 06/10/23.
//

import SwiftUI

private struct LeafText: View {
    var body: some View {
        Text("1 like")
            .label()
        Text("How came first, the egg or the chicken?")
            .title()
        Text("The chicken, sure!")
            .subtitle()
        Text("Evidence")
            .body()
    }
}
#Preview {
    LeafText()
}

//MARK: -TitleModifier
public struct LeafTitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.titleLarge)
            .bold()
            .lineSpacing(theme.size.lineSpacingTitle)
            .foregroundStyle(theme.color.content.primary)

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
            .foregroundStyle(theme.color.content.secondary)
        
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
            .foregroundStyle(theme.color.content.secondary)
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
            .foregroundStyle(theme.color.content.tertiary)
    }
}
public extension Text {
    func label() -> some View {
        self.modifier(LeafLabelModifier())
    }
}
