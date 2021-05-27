//
//  InButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add the content in a button.
 */
fileprivate struct InButton: ViewModifier {
    
    // MARK: - Properties
    
    /// Action to perform when button is hitten.
    private let action: () -> Void
    /// Boolean indicating whether the button is disabled or not.
    private var isDisabled: Bool?
    /// Unwrapped isDisabled property.
    private var disablingButton: Bool {
        if let isDisabled = isDisabled {
            return isDisabled
        } else {
            return false
        }
    }
    
    // MARK: - Init
    
    init(isDisabled: Bool?, action: @escaping () -> Void) {
        self.action = action
        self.isDisabled = isDisabled
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        Button(action: action, label: {
            content
                .withLinkFont(isDisabled)
        })
        .disabled(disablingButton)
    }
}

// MARK: - View's extension

extension View {
    /**
     Add the content in a button.
     - parameter isDisabled: Boolean indicating whether the button is disabled or not *(optional)*.
     - parameter action: Action to perform when button is hitten.
     */
    func inButton(isDisabled: Bool? = nil, action: @escaping () -> Void) -> some View {
        modifier(InButton(isDisabled: isDisabled, action: action))
    }
}
