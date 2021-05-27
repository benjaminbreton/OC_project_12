//
//  SettingsCustomToggle.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI

// MARK: - Custom toggle without explanations

/**
 Toggle without explanations in a settings module.
 */
struct SettingsCustomToggle: View {
    
    // MARK: - Properties
    
    /// Boolean indicating whether the toggle is on or off.
    @Binding var isOn: Bool
    /// Module's title.
    let title: String
    /// Question to display next to the toggle.
    let question: String
    
    // MARK: - Init
    
    init(title: String, question: String, isOn: Binding<Bool>) {
        self.title = title
        self.question = question
        self._isOn = isOn
    }
    
    // MARK: - Body
    
    var body: some View {
        Toggle(question, isOn: _isOn)
            .inModule(title)
    }
}
/**
 Toggle with explanations in a settings module.
 */
struct SettingsCustomToggleWithExplanations: View {
    
    // MARK: - Properties
    
    /// Boolean indicating whether the toggle is on or off.
    @Binding var isOn: Bool
    /// Module's title.
    let title: String
    /// Question to display next to the toggle.
    let question: String
    /// Explanations to display when toggle is On.
    let explanationsAreOn: String
    /// Explanations to display when toggle is Off.
    let explanationsAreOff: String
    /// Explanations text number of lines.
    let textLines: CGFloat
    
    // MARK: - Init
    
    init(title: String, question: String, isOn: Binding<Bool>, explanationsAreOn: String, explanationsAreOff: String, textLines: CGFloat) {
        self.title = title
        self.question = question
        self.explanationsAreOn = explanationsAreOn
        self.explanationsAreOff = explanationsAreOff
        self.textLines = textLines
        self._isOn = isOn
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Toggle(question, isOn: _isOn)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            Text(isOn ? explanationsAreOn : explanationsAreOff)
                .withLightSimpleFont()
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .inModule(title)
    }
}
