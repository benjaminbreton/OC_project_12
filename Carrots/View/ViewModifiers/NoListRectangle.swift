//
//  NoListRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct NoListRectangle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                .foregroundColor(.backCell)
                .opacity(ViewCommonSettings().commonOpacity)
            content
                .padding()
        }
        .padding()
    }
}
