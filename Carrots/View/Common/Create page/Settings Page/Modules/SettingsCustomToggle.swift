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
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            Text(isOn ? explanationsAreOn : explanationsAreOff)
                .withLightSimpleFont()
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .inModule(title)
    }
}
