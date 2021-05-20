//
//  String+Localization.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/05/2021.
//

import Foundation
extension String {
    var localized: String { NSLocalizedString(self, comment: .init()) }
}
