//
//  Fonts.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct BigTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().titleFontName, size: ViewCommonSettings().bigTitleFontSize))
            .foregroundColor(.title)
    }
}
struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.title)
    }
}
struct SimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().regularFontSize))
            .foregroundColor(.text)
    }
}
struct BigSimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.text)
    }
}
struct LightSimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().lightFontSize))
            .foregroundColor(.textLight)
    }
}
struct LinkFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.link)
    }
}
struct SportIconFont: ViewModifier {
    let multiplier: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().iconsFontName, size: ViewCommonSettings().regularFontSize * multiplier))
            .foregroundColor(.image)
    }
}
