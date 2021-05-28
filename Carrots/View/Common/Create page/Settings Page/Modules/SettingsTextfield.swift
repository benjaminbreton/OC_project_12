//
//  CustomTextfield.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
/**
 A textfield displayed in a module.
 */
struct SettingsTextfield: View {
    
    // MARK: - Properties
    
    /// An observable object used to observe the textfield's value.
    @ObservedObject private var textFieldValue: TextFieldValue
    /// Explanations to display if an error has been detected.
    @State private var wrongExplanations: String?
    /// The setted value in the textfield.
    @Binding private var value: String
    /// The module's title.
    private let title: String
    /// The placeholder to display in the textfield.
    private let placeholder: String
    /// The keyboard's type.
    private let keyboard: UIKeyboardType
    /// The module's explanations.
    private let explanations: String?
    /// Boolean indicating whether an error has been detected on module's changes, or not.
    private var isWrong: Binding<Bool>?
    
    // MARK: - Init
    
    init(title: String, placeholder: String, value: Binding<String>, keyboard: UIKeyboardType, explanations: String? = nil, isWrong: Binding<Bool>? = nil, limits: TextFieldValue.Limits = nil, limitsExplanations: TextFieldValue.LimitsExplanations = nil) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
        self.keyboard = keyboard
        self.explanations = explanations
        self.textFieldValue = TextFieldValue(value.wrappedValue, limits: limits, limitsExplanations: limitsExplanations)
        self.isWrong = isWrong
        
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $textFieldValue.text)
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
        .inModule(title,
                  explanations: explanations,
                  isWrong: isWrong,
                  wrongExplanations: wrongExplanations)
    }
}
/**
 A class used to observe the setted value in a textfield.
 */
class TextFieldValue: ObservableObject {
    
    // MARK: - Limits typealias
    
    /// Characters count limits for the setted value.
    typealias Limits = (minCount: Int?, maxCount: Int?)?
    /// Explanations to display if limits have been surpassed.
    typealias LimitsExplanations = (minCount: String?, maxCount: String?)?
    
    // MARK: - Properties
    
    /// The setted value.
    @Published var text: String
    /// Characters count limits for the setted value.
    private let limits: (minCount: Int?, maxCount:Int?)?
    /// Explanations to display if limits have been surpassed.
    private let explanations: (minCount: String?, maxCount: String?)?
    
    // MARK: - Init
    
    init(_ text: String, limits: Limits, limitsExplanations: LimitsExplanations) {
        self.text = text
        self.limits = limits
        self.explanations = limitsExplanations
    }
    
    // MARK: - Control
    
    /**
     Control setted regarding the limits.
     - returns: The new text.
     */
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

