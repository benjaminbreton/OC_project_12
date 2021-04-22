//
//  ViewCommonSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

/// Common properties used to get a responsive application.
class ViewCommonSettings {
    
    // MARK: - Common opacity
    
    let commonOpacity: Double = 0.2
    
    // MARK: - Common cornerRadius
    
    let commonCornerRadius: CGFloat = UIScreen.main.bounds.height * 10 / 844
    
    // MARK: - Height - width
    
    var commonPotLineHeight: CGFloat {
        UIScreen.main.bounds.height / 10
    }
    var commonHeight: CGFloat {
        UIScreen.main.bounds.height / 100 * 2
    }
    var strokeLineWidth: CGFloat {
        5 * UIScreen.main.bounds.height / 844
    }
    var textLineHeight: CGFloat {
        2 * commonHeight
    }
    var shapeLine: CGFloat {
        3
    }
    var performanceCellMultiplier: CGFloat {
        4
    }
    var performanceCellRowHeight: CGFloat {
        ViewCommonSettings().commonHeight * performanceCellMultiplier * 2
    }
    
    // MARK: - Font size
    
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
    
    // MARK: - Font name
    
    let regularFontName: String = "kirsty"
    let titleFontName: String = "akaPosse"
    let iconsFontName: String = "sportstfb"
    
    // MARK: - UIFonts
    
    var regularNavigationTitleFont: UIFont {
        guard let regularTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().regularFontSize) else { return UIFont() }
        return regularTitleFont
    }
    var largeNavigationTitleFont: UIFont {
        guard let largeTitleFont = UIFont(name: "akaPosse", size: ViewCommonSettings().navigationTitleFontSize) else { return UIFont() }
        return largeTitleFont
    }
    
    // MARK: - Specials
    
    var sportsIconsCharacters: [String] {
        let characters = "ABEHKMOTWXZabfntw8$*/='#@&_;!|{}]"
        return characters.map({ "\($0)" })
    }
    
}

