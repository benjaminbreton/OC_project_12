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
    var isDisabled: Binding<Bool>?
    private var disablingButton: Bool {
        if let isDisabled = isDisabled {
            return isDisabled.wrappedValue
        } else {
            return false
        }
    }
    init(isDisabled: Binding<Bool>?, action: @escaping () -> Void) {
        self.action = action
        self.isDisabled = isDisabled
    }
    func body(content: Content) -> some View {
        Button(action: action, label: {
            content
                .withLinkFont(isDisabled)
        })
        .disabled(disablingButton)
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
    func inButton(isDisabled: Binding<Bool>? = nil, action: @escaping () -> Void) -> some View {
        modifier(InButton(isDisabled: isDisabled, action: action))
    }
    func inDeleteButton(action: @escaping () -> Void) -> some View {
        modifier(InDeleteButton(action: action))
    }
}
