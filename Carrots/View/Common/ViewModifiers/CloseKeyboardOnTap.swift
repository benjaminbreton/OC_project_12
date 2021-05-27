//
//  CloseKeyboardOnTap.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add a gesture in the content to close keyboard when content is hitten.
 */
fileprivate struct CloseKeyboardOnTap: ViewModifier {
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

// MARK: - View's extension

extension View {
    /**
     Add a gesture in the content to close keyboard when content is hitten.
     - returns: The content with the gesture.
     */
    func closeKeyboardOnTap() -> some View {
        modifier(CloseKeyboardOnTap())
    }
}
