//
//  UIColor+appColors.swift
//  Carrots
//
//  Created by Benjamin Breton on 17/04/2021.
//

import SwiftUI
extension UIColor {
    static var pickerText: UIColor {
        guard let color = UIColor(named: "lightOrange") else { return .black }
        return color
    }
    static var pickerBackground: UIColor {
        guard let color = UIColor(named: "darkGrey") else { return .orange }
        return color
    }
}
