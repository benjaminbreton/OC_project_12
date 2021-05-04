//
//  InSettingsModule.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
fileprivate struct InModule: ViewModifier {
    let title: String?
    let alignment: Alignment
    func body(content: Content) -> some View {
        VStack {
            if let title = title {
                Text(title)
                    .withTitleFont()
            }
            content
                .inRectangle(alignment)
                .withSimpleFont()
        }
    }
}
extension View {
    func inModule(_ title: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .leading))
    }
    func inCenteredModule(_ title: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .center))
    }
}
