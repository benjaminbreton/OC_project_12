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
    let explanations: String?
    func body(content: Content) -> some View {
        VStack {
            if let title = title {
                Text(title)
                    .withTitleFont()
            }
            VStack {
                if let explanations = explanations {
                    Text(explanations)
                        .withLightSimpleFont()
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                content
            }
            .inRectangle(alignment)
            .withSimpleFont()
        }
    }
}
extension View {
    func inModule(_ title: String? = nil, explanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .leading, explanations: explanations))
    }
    func inCenteredModule(_ title: String? = nil, explanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .center, explanations: explanations))
    }
}
