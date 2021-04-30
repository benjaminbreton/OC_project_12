//
//  Fonts.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifiers

fileprivate struct BigTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().titleFontName, size: ViewCommonSettings().bigTitleFontSize))
            .foregroundColor(.title)
    }
}
fileprivate struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.title)
    }
}
fileprivate struct SimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().regularFontSize))
            .foregroundColor(.text)
    }
}
fileprivate struct BigSimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.text)
    }
}
fileprivate struct LightSimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().lightFontSize))
            .foregroundColor(.textLight)
    }
}
fileprivate struct LinkFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.link)
    }
}
fileprivate struct SportIconFont: ViewModifier {
    let lineCount: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().iconsFontName, size: ViewCommonSettings().regularFontSize * lineCount))
            .foregroundColor(.image)
    }
}

// MARK: - View's extensions

extension View {
    func withTitleFont() -> some View {
        modifier(TitleFont())
    }
    func withSimpleFont() -> some View {
        modifier(SimpleFont())
    }
    func withLightSimpleFont() -> some View {
        modifier(LightSimpleFont())
    }
    func withBigSimpleFont() -> some View {
        modifier(BigSimpleFont())
    }
    func withLinkFont() -> some View {
        modifier(LinkFont())
    }
    func withBigTitleFont() -> some View {
        modifier(BigTitleFont())
    }
    func withSportIconFont(lineCount: CGFloat) -> some View {
        modifier(SportIconFont(lineCount: lineCount))
    }
}
