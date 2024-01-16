//
//  LeafTextExtensions.swift
//
//
//  Created by Cris Messias on 16/01/24.
//

import SwiftUI

extension Bundle {
    private class CurrentBundleFinder {}

    public static var components: Bundle  = {
        let bundleNameIOS = "Leaf_Leaf"
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
            Bundle(for: CurrentBundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent(),
            Bundle(for: CurrentBundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent(),
        ]
        for candidate in candidates {
            let bundlePathiOS = candidate?.appendingPathComponent(bundleNameIOS + ".bundle")
            if let bundle = bundlePathiOS.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("Can't find Components custom bundle. See LeafTextExtensions.swift")
    }()
}

public enum CustomFonts {
    public static func registerCustomFonts() {
        for font in ["Lato-Black.ttf", "Lato-Regular.ttf", "Lato-Bold.ttf", "Lato-Light.ttf"] {
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
