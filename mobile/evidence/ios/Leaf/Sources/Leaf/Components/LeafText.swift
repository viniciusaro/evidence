//
//  LeafText.swift
//  
//
//  Created by Cris Messias on 06/10/23.
//

import SwiftUI

//MARK: - TitleModifier

public struct TitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.titleLarge)
            .bold()
            .lineSpacing(0.2)
            .foregroundStyle(theme.color.content.primary)

    }
}
public extension View {
    func titleModifier() -> some View {
        self.modifier(TitleModifier())
    }
}

//MARK: - SubtitleModifier

public struct SubtitleModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.subtitle)
            .bold()
            .foregroundStyle(theme.color.content.secondary)
        
    }
}
public extension View {
    func subtitleModifier() -> some View {
        self.modifier(SubtitleModifier())
    }
}

//MARK: - BodyModifier

public struct BodyModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.body)
            .foregroundStyle(theme.color.content.secondary)
    }
}
public extension View {
    func bodyModifier() -> some View {
        self.modifier(BodyModifier())
    }
}

//MARK: - LabelModifier

public struct LabelModifier: ViewModifier {
    @Environment(\.leafTheme) private var theme
    public func body(content: Content) -> some View {
        content
            .font(theme.font.label)
            .bold()
            .foregroundStyle(theme.color.content.tertiary)
    }
}
public extension View {
    func labelModifier() -> some View {
        self.modifier(LabelModifier())
    }
}
