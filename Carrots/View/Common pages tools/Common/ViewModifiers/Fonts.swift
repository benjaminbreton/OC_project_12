//
//  Fonts.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifiers

fileprivate struct NavigationButtonFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().titleFontName, size: ViewCommonSettings().bigTitleFontSize))
            .foregroundColor(.link)
    }
}
fileprivate struct AthleticImageButtonFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().titleFontName, size: ViewCommonSettings().navigationTitleFontSize))
            .foregroundColor(.link)
    }
}
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
fileprivate struct AlertBlockTextFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().regularFontSize))
            .foregroundColor(.alertBlockText)
    }
}
fileprivate struct AlertBlockImageFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().bigTitleFontSize))
            .foregroundColor(.alertBlockImage)
    }
}
fileprivate struct DeleteFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().lightFontSize))
            .foregroundColor(.delete)
    }
}
fileprivate struct LinkFont: ViewModifier {
    var isLinkDisabled: Bool?
    private var disablingLink: Bool {
        if let isLinkDisabled = isLinkDisabled {
            return isLinkDisabled
        }
        return false
    }
    func body(content: Content) -> some View {
        content
            .font(.custom(ViewCommonSettings().regularFontName, size: ViewCommonSettings().titleFontSize))
            .foregroundColor(disablingLink ? .textLight : .link)
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
    func withLinkFont(_ isLinkDisabled: Bool? = nil) -> some View {
        modifier(LinkFont(isLinkDisabled: isLinkDisabled))
    }
    func withBigTitleFont() -> some View {
        modifier(BigTitleFont())
    }
    func withSportIconFont(lineCount: CGFloat) -> some View {
        modifier(SportIconFont(lineCount: lineCount))
    }
    func withDeleteFont() -> some View {
        modifier(DeleteFont())
    }
    func withNavigationButtonFont() -> some View {
        modifier(NavigationButtonFont())
    }
    func withAthleticImageButtonFont() -> some View {
        modifier(AthleticImageButtonFont())
    }
    func withAlertBlockTextFont() -> some View {
        modifier(AlertBlockTextFont())
    }
    func withAlertBlockImageFont() -> some View {
        modifier(AlertBlockImageFont())
    }
}
