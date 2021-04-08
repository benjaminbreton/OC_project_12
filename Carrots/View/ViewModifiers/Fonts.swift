//
//  Fonts.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct BigTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("akaPosse", size: ViewCommonSettings().bigTitleFontSize))
    }
}
struct TitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("kirsty", size: ViewCommonSettings().titleFontSize))
    }
}
struct SimpleFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom("kirsty", size: ViewCommonSettings().regularFontSize))
    }
}
