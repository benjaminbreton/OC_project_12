//
//  InSettingsModule.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
fileprivate struct InSettingsModule: ViewModifier {
    let title: String
    let alignment: Alignment
    func body(content: Content) -> some View {
        VStack {
            Text(title)
                .withTitleFont()
            content
                .inRectangle(alignment)
                .withSimpleFont()
        }
    }
}
extension View {
    func inSettingsModule(_ title: String) -> some View {
        modifier(InSettingsModule(title: title, alignment: .leading))
    }
    func inCenteredSettingsModule(_ title: String) -> some View {
        modifier(InSettingsModule(title: title, alignment: .center))
    }
}
