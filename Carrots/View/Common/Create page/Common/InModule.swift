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
    var isWrong: Binding<Bool>?
    let wrongExplanations: String?
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
                if let isWrong = isWrong {
                    if isWrong.wrappedValue, let explanations = wrongExplanations {
                        Text(explanations)
                            .withDeleteFont()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                content
            }
            .inRectangle(alignment)
            .withSimpleFont()
        }
    }
}
extension View {
    func inModule(_ title: String? = nil, explanations: String? = nil, isWrong: Binding<Bool>? = nil, wrongExplanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .leading, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations))
    }
    func inCenteredModule(_ title: String? = nil, explanations: String? = nil, isWrong: Binding<Bool>? = nil, wrongExplanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .center, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations))
    }
}
