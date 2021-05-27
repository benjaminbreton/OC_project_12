//
//  InRectangle.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add the content in a rectangle with a light opacity background.
 */
fileprivate struct InRectangle: ViewModifier {
    
    // MARK: - Property
    
    /// Content's alignment.
    private let alignment: Alignment
    
    // MARK: - Init
    
    init(alignment: Alignment) {
        self.alignment = alignment
    }
    
    // MARK: - Body
    
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

// MARK: - View's extension

extension View {
    /**
     Add the content in a rectangle with a light opacity background.
     - parameter alignment: The content's alignment.
     - returns: The content in a rectangle with a light opacity background.
     */
    func inRectangle(_ alignment: Alignment) -> some View {
        modifier(InRectangle(alignment: alignment))
    }
}
