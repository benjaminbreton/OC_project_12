//
//  CustomTextfield.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct SettingsCustomTextfield: View {
    let title: String
    let placeHolder: String
    @Binding var value: String
    let keyboard: UIKeyboardType
    var body: some View {
        TextField(placeHolder, text: _value)
            .frame(height: ViewCommonSettings().textLineHeight)
            .keyboardType(keyboard)
            .inSettingsModule(title)
    }
}

