//
//  InCellRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct InCellRectangle: ViewModifier {
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
