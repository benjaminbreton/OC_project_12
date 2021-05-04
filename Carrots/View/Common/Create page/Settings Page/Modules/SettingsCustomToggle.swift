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
            .inSettingsModule(title)
    }
}
struct SettingsCustomToggleWithExplications: View {
    let title: String
    let question: String
    @Binding var isOn: Bool
    let explicationsIsOn: String
    let explicationsIsOff: String
    let textLines: CGFloat
    var body: some View {
        VStack {
            Toggle(question, isOn: _isOn)
            Text(isOn ? explicationsIsOn : explicationsIsOff)
                .frame(height: ViewCommonSettings().textLineHeight * textLines)
                .withLightSimpleFont()
        }
        .inSettingsModule(title)
    }
}
