//
//  InRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct InRectangle: ViewModifier {
    let alignment: Alignment
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                .foregroundColor(.backCell)
                .opacity(ViewCommonSettings().commonOpacity)
            content
                .padding()
        }
        .padding()
    }
}
