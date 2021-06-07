//
//  WithBackground.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add a background behind the content.
 */
fileprivate struct WithBackground: ViewModifier {
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.backgroundFirst, .backgroundSecond]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            content
                .zIndex(1)
        }
    }
}

// MARK: - View's extension

extension View {
    /**
     Add a background behind the content.
     - returns: The content with the app's background.
     */
    func withAppBackground() -> some View {
        modifier(WithBackground())
    }
}
