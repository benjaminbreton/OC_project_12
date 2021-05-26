//
//  ViewCommonSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

/// Common properties used to get a smooth and responsive application.
class ViewCommonSettings {
    
    // MARK: - Common opacity
    
    /// Opacity used for cells backgrounds.
    let commonOpacity: Double = 0.2
    
    // MARK: - Common cornerRadius
    
    /// Corner radius used for cells rectangle.
    let commonCornerRadius: CGFloat = UIScreen.main.bounds.height * 10 / 844
    
    // MARK: - Height - width
    
    /// Used to get a responsive size base.
    var commonSizeBase: CGFloat { UIScreen.main.bounds.height / 50 }
    /// Used by sport icon selector to identify the selected icon with a stroked circle.
    var strokeLineWidth: CGFloat { 3 * commonSizeBase }
    /// The height of a text line.
    var textLineHeight: CGFloat { 2 * commonSizeBase }
    /// The line width of the athletic's evolution graph.
    var graphLineWidth: CGFloat { 3 }
    
    // MARK: - Font size
    
    /// Used to get a responsive font size.
    private var commonFontSizeBase: CGFloat { UIScreen.main.bounds.height / 42 }
    /// Regular font size.
    var regularFontSize: CGFloat { commonFontSizeBase }
    /// Font size used for light text.
    var lightFontSize: CGFloat { commonFontSizeBase * 0.75 }
    /// Font size used for regular titles.
    var titleFontSize: CGFloat { commonFontSizeBase * 1.5 }
    /// Font size used for big titles.
    var bigTitleFontSize: CGFloat { commonFontSizeBase * 1.5 }
    /// Font size used for navigation titles.
    var navigationTitleFontSize: CGFloat { commonFontSizeBase * 2.5 }
    
    // MARK: - Font name
    
    /// Font used for texts.
    let regularFontName: String = "kirsty"
    /// Font used for titles.
    let titleFontName: String = "akaPosse"
    /// Font used for sports icons.
    let iconsFontName: String = "sportive"
    
    // MARK: - UIFonts
    
    /// UIFont used for navigation titles.
    var largeNavigationTitleFont: UIFont {
        guard let largeTitleFont = UIFont(name: titleFontName, size: ViewCommonSettings().navigationTitleFontSize) else { return UIFont() }
        return largeTitleFont
    }
    
    // MARK: - Specials
    
    /// Characters used to choose a sport's icon.
    var sportsIconsCharacters: [String] {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".map({ "\($0)" })
    }
    
}

