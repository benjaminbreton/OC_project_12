//
//  InButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct InButton: ViewModifier {
    let action: () -> Void
    func body(content: Content) -> some View {
        Button(action: action, label: {
            content
                .withLinkFont()
        })
    }
}
