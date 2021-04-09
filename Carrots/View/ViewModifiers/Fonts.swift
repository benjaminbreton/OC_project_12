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
            .font(.custom("akaPosse", size: ViewCommonSettings().bigTitleFontSize))
            .foregroundColor(.title)
    }
}
struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("kirsty", size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.title)
    }
}
struct SimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("kirsty", size: ViewCommonSettings().regularFontSize))
            .foregroundColor(.text)
    }
}
struct BigSimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("kirsty", size: ViewCommonSettings().titleFontSize))
            .foregroundColor(.text)
    }
}
struct LinkFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("kirsty", size: ViewCommonSettings().regularFontSize))
            .foregroundColor(.link)
    }
}
