//
//  InCellRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
fileprivate struct InCellRectangle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                .foregroundColor(.backCell)
                .opacity(ViewCommonSettings().commonOpacity)
            content
        }
        .padding()
    }
}
extension View {
    func inCellRectangle() -> some View {
        modifier(InCellRectangle())
    }
}
