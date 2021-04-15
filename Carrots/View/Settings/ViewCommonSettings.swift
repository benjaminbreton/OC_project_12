//
//  ViewCommonSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
class ViewCommonSettings {
    var commonPotLineHeight: CGFloat {
        UIScreen.main.bounds.height / 10
    }
    var regularFontSize: CGFloat {
        20 * UIScreen.main.bounds.height / 844
    }
    var lightFontSize: CGFloat {
        regularFontSize * 0.75
    }
    var titleFontSize: CGFloat {
        regularFontSize * 1.5
    }
    var bigTitleFontSize: CGFloat {
        regularFontSize * 1.5
    }
    var navigationTitleFontSize: CGFloat {
        regularFontSize * 2.5
    }
    var navigationButtonSize: CGFloat {
        30 * UIScreen.main.bounds.height / 844
    }
    let regularFontName: String = "kirsty"
    let titleFontName: String = "akaPosse"
    let iconsFontName: String = "sportstfb"
    var regularNavigationTitleFont: UIFont {
        guard let regularTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().regularFontSize) else { return UIFont() }
        return regularTitleFont
    }
    var largeNavigationTitleFont: UIFont {
        guard let largeTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().navigationTitleFontSize) else { return UIFont() }
        return largeTitleFont
    }
    var commonHeight: CGFloat {
        UIScreen.main.bounds.height / 100 * 2
    }
    var sportsIconsCharacters: [String] {
        let characters = "ABEHKMOTWXZabfntw8$*/='#@&_;!|{}]"
        return characters.map({ "\($0)" })
    }
    var lineWidth: CGFloat {
        5 * UIScreen.main.bounds.height / 844
    }
}
