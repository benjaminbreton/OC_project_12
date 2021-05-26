//
//  InRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
fileprivate struct InRectangle: ViewModifier {
    let alignment: Alignment
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                .foregroundColor(.backCell)
                .opacity(ViewCommonSettings().commonOpacity)
            content
                .padding()
        }
        .padding(ViewCommonSettings().commonSizeBase / 2)
    }
}
extension View {
    func inRectangle(_ alignment: Alignment) -> some View {
        modifier(InRectangle(alignment: alignment))
    }
}
