//
//  NavigationPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add the content in a page with a navigation bar's title and the app's background.
 */
fileprivate struct InNavigationPage: ViewModifier {
    
    // MARK: - Properties
    
    /// The navigation bar's title.
    private let title: String
    
    // MARK: - Init
    
    init(title: String) {
        self.title = title
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        // Add the content in a page with a navigation bar's title and the app's background.
        content
            .navigationBarTitle(Text(title))
            .withAppBackground()
    }
}

// MARK: - View's extension

extension View {
    /**
     Add the content in a page with a navigation bar's title and the app's background.
     - parameter title: The navigation bar's title.
     - returns: The content in a page with a navigation bar's title and the app's background.
     */
    func inNavigationPage(_ title: String) -> some View {
        modifier(InNavigationPage(title: title))
    }
}


