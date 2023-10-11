//
//  LeafText.swift
//  
//
//  Created by Cris Messias on 06/10/23.
//

import SwiftUI

private struct LeafText: View {
    var body: some View {
        Text("Evidence")
            .subtitle()
        Text("Who come first: the egg or the chicken?")
            .title()
        Text("The egg, sure!")
            .body()
        Text("1 like")
            .label()
        
    }
}

#Preview {
    LeafText()
}

//MARK: - TitleModifier
public extension Text {
    func title() -> some View {
        @Environment(\.leafTheme)  var theme
        return self
            .font(theme.font.titleLarge)
            .bold()
            .lineSpacing(theme.size.lineSpacingTitle)
            .foregroundStyle(theme.color.content.primary)
    }
}


//MARK: - SubtitleModifier
public extension Text {
    func subtitle() -> some View {
        @Environment(\.leafTheme)  var theme
        return self
            .font(theme.font.subtitle)
            .bold()
            .foregroundStyle(theme.color.content.secondary)
    }
}

//MARK: - BodyModifier
public extension Text {
    func body() -> some View {
        @Environment(\.leafTheme)  var theme
        return self
            .font(theme.font.body)
            .foregroundStyle(theme.color.content.secondary)
    }
}

//MARK: - LabelModifier
public extension Text {
    func label() -> some View {
        @Environment(\.leafTheme)  var theme
        return self
            .font(theme.font.label)
            .bold()
            .foregroundStyle(theme.color.content.tertiary)
    }
}
