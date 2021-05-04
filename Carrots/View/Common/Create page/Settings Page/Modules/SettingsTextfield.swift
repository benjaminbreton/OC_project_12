//
//  CustomTextfield.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct SettingsTextfield: View {
    let title: String
    let placeHolder: String
    @Binding var value: String
    let keyboard: UIKeyboardType
    let explanations: String?
    init(title: String, placeHolder: String, value: Binding<String>, keyboard: UIKeyboardType, explanations: String? = nil) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.keyboard = keyboard
        self.explanations = explanations
    }
    var body: some View {
        VStack {
            if let explanations = explanations {
                Text(explanations)
                    .withLightSimpleFont()
            }
            TextField(placeHolder, text: _value)
                .frame(height: ViewCommonSettings().textLineHeight)
                .keyboardType(keyboard)
        }
        .inModule(title)
    }
}

