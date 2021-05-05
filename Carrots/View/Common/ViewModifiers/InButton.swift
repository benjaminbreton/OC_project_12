//
//  InButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct InButton: ViewModifier {
    let action: () -> Void
    func body(content: Content) -> some View {
        Button(action: action, label: {
            content
                .withLinkFont()
        })
    }
}
fileprivate struct InDeleteButton: ViewModifier {
    let action: () -> Void
    func body(content: Content) -> some View {
        Button(action: action) {
            content
                .withDeleteFont()
        }
    }
}

// MARK: - View's extension

extension View {
    func inButton(action: @escaping () -> Void) -> some View {
        modifier(InButton(action: action))
    }
    func inDeleteButton(action: @escaping () -> Void) -> some View {
        modifier(InDeleteButton(action: action))
    }
}
