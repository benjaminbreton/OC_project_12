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
    let wrongCount: Int?
    let wrongExplanations: String?
    var isWrong: Binding<Bool>?
    @ObservedObject var textFieldValue: TextFieldValue
    
    init(title: String, placeHolder: String, value: Binding<String>, keyboard: UIKeyboardType, explanations: String? = nil, isWrong: Binding<Bool>? = nil, wrongCount: Int? = nil, wrongExplanations: String? = nil) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.keyboard = keyboard
        self.explanations = explanations
        self.wrongExplanations = wrongExplanations
        self.wrongCount = wrongCount
        self.textFieldValue = TextFieldValue(value.wrappedValue)
        self.isWrong = isWrong
        
    }
    var body: some View {
        VStack {
            TextField(placeHolder, text: $textFieldValue.text)
                .frame(height: ViewCommonSettings().textLineHeight)
                .keyboardType(keyboard)
                .onReceive(textFieldValue.$text) { newValue in
                    value = newValue
                    if let count = wrongCount {
                        if newValue.count >= count {
                            isWrong?.wrappedValue = true
                        } else {
                            isWrong?.wrappedValue = false
                        }
                    } else {
                        isWrong?.wrappedValue = false
                    }
                }
        }
        .inModule(title, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations)
    }
}

 class TextFieldValue: ObservableObject {
    @Published var text: String
    init(_ text: String) { self.text = text }
}

