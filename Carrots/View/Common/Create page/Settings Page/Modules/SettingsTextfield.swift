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
    var isWrong: Binding<Bool>?
    @ObservedObject var textFieldValue: TextFieldValue
    @State var wrongExplanations: String?
    init(title: String, placeHolder: String, value: Binding<String>, keyboard: UIKeyboardType, explanations: String? = nil, isWrong: Binding<Bool>? = nil, limits: TextFieldValue.Limits = nil, limitsExplanations: TextFieldValue.LimitsExplanations = nil) {
        self.title = title
        self.placeHolder = placeHolder
        self._value = value
        self.keyboard = keyboard
        self.explanations = explanations
        self.textFieldValue = TextFieldValue(value.wrappedValue, limits: limits, limitsExplanations: limitsExplanations)
        self.isWrong = isWrong
        
    }
    var body: some View {
        VStack {
            TextField(placeHolder, text: $textFieldValue.text)
                .frame(height: ViewCommonSettings().textLineHeight)
                .keyboardType(keyboard)
                .onReceive(textFieldValue.$text) { newValue in
                    value = newValue
                    if let explanations = textFieldValue.control() {
                        wrongExplanations = explanations
                        isWrong?.wrappedValue = true
                    } else {
                        isWrong?.wrappedValue = false
                    }
                }
        }
        .inModule(title, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations)
    }
}

class TextFieldValue: ObservableObject {
    typealias Limits = (minCount: Int?, maxCount:Int?)?
    typealias LimitsExplanations = (minCount: String?, maxCount: String?)?
    
    @Published var text: String
    
    let limits: (minCount: Int?, maxCount:Int?)?
    let explanations: (minCount: String?, maxCount: String?)?
    init(_ text: String, limits: Limits, limitsExplanations: LimitsExplanations) {
        self.text = text
        self.limits = limits
        self.explanations = limitsExplanations
    }
    func control() -> String? {
        guard let limits = limits, let explanations = explanations else { return nil }
        if let count = limits.minCount, text.count < count {
            return explanations.minCount
        }
        if let count = limits.maxCount, text.count > count {
            return explanations.maxCount
        }
        return nil
    }
}

