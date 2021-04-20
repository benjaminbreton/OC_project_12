//
//  UIFont+appFonts.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
extension UIFont {
    static var pickerFont: UIFont {
        guard let font = UIFont(name: "kirsty", size: ViewCommonSettings().regularFontSize) else { return .systemFont(ofSize: ViewCommonSettings().regularFontSize) }
        return font
    }
}
