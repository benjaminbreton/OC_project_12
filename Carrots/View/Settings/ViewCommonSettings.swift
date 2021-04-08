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
        return 20 * UIScreen.main.bounds.height / 844
    }
    var titleFontSize: CGFloat {
        return regularFontSize * 1.5
    }
    var bigTitleFontSize: CGFloat {
        return regularFontSize * 1.5
    }
    var navigationTitleFontSize: CGFloat {
        return regularFontSize * 2.5
    }
    var navigationButtonSize: CGFloat {
        return 30 * UIScreen.main.bounds.height / 844
    }
    var regularNavigationTitleFont: UIFont {
        guard let regularTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().regularFontSize) else { return UIFont() }
        return regularTitleFont
    }
    var largeNavigationTitleFont: UIFont {
        guard let largeTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().navigationTitleFontSize) else { return UIFont() }
        return largeTitleFont
    }
}
