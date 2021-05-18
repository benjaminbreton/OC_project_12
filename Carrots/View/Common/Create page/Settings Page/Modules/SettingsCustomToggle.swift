//
//  SettingsCustomToggle.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
struct SettingsCustomToggle: View {
    let title: String
    let question: String
    @Binding var isOn: Bool
    var body: some View {
        Toggle(question, isOn: _isOn)
            .inModule(title)
    }
}
struct SettingsCustomToggleWithExplanations: View {
    let title: String
    let question: String
    @Binding var isOn: Bool
    let explanationsAreOn: String
    let explanationsAreOff: String
    let textLines: CGFloat
    var body: some View {
        VStack {
            Toggle(question, isOn: _isOn)
            Text(isOn ? explanationsAreOn : explanationsAreOff)
                .frame(height: ViewCommonSettings().textLineHeight * textLines)
                .withLightSimpleFont()
        }
        .inModule(title)
    }
}
