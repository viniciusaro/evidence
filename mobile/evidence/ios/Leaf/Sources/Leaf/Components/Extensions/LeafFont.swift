//
//  SwiftUIView.swift
//  
//
//  Created by Cris Messias on 11/01/24.
//

import SwiftUI

extension Font {
    public static let titleBoldLeaf = Font.custom("Lato-Bold", size: 18)
    public static let subtitleRegularLeaf = Font.custom("Lato-Regular", size: 16)
    public static let bodyLeaf = Font.custom("Lato-Regular", size: 16)
    public static let headlineLightLeaf = Font.custom("Lato-Light", size: 12)

}

public enum CustomFonts {
    public static func registerCustomFonts() {
        for font in ["Lato-Regular.ttf", "Lato-Bold.ttf", "Lato-Light.ttf"] {
            guard let url = Bundle.components.url(forResource: font, withExtension: nil) else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

extension View {
    public func previewCustomFonts() -> some View {
        CustomFonts.registerCustomFonts()
        return self
    }
}
