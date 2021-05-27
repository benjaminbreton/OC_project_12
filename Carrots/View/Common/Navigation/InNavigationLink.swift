//
//  InNavigationLink.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add the content in a navigation link.
 */
fileprivate struct InNavigationLink<T: View>: ViewModifier {
    
    // MARK: - Properties
    
    /// The link's destination.
    private let destination: T
    
    // MARK: - Init
    
    init(destination: T) {
        self.destination = destination
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        // add the content in a navigation link
        NavigationLink(
            destination: destination,
            label: {
                content
            })
    }
}

// MARK: - View's extension

extension View {
    /**
     Add the content in a navigation link.
     - parameter destination: The link's destination.
     - returns: The content in a navigation link.
     */
    func inNavigationLink<T: View>(_ destination: T) -> some View {
        modifier(InNavigationLink(destination: destination))
    }
}
