//
//  CustomTextfield.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct CustomTextfield: View {
    let title: String
    let placeHolder: String
    @Binding var value: String
    let keyboard: UIKeyboardType
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            TextField(placeHolder, text: _value)
                .withSimpleFont()
                .frame(height: ViewCommonSettings().lineHeight)
                .keyboardType(keyboard)
                .inRectangle(.center)
        }
    }
}

