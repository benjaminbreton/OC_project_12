//
//  CustomToggle.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
struct CustomToggle: View {
    let title: String
    let question: String
    @Binding var isOn: Bool
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            Toggle(question, isOn: _isOn)
                .withSimpleFont()
                .inRectangle(.center)
        }
    }
}
struct CustomToggleWithExplications: View {
    let title: String
    let question: String
    @Binding var isOn: Bool
    let explicationsIsOn: String
    let explicationsIsOff: String
    let textLines: CGFloat
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            VStack {
                Toggle(question, isOn: _isOn)
                Text(isOn ? explicationsIsOn : explicationsIsOff)
                    .frame(height: ViewCommonSettings().lineHeight * textLines)
                    .foregroundColor(.textLight)
            }
            .withSimpleFont()
            .inRectangle(.center)
        }
    }
}
