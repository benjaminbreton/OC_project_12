//
//  InNavigationHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Add the content in a new navigation stack with the app's background.
 */
fileprivate struct InNavigationHome<T: View>: ViewModifier {
    
    // MARK: - Properties
    
    /// Navigation bar's title.
    private let title: String
    /// Navigation bar's button's image's title.
    private let buttonImage: String
    /// The button's destination.
    private let buttonDestination: T?
    
    // MARK: - Init
    
    init(title: String, buttonImage: String, buttonDestination: T?) {
        self.title = title
        self.buttonImage = buttonImage
        self.buttonDestination = buttonDestination
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        // create the navigation stack
        NavigationView {
            content
                .withAppBackground()
                .navigationBarTitle(Text(title))
                .navigationBarItems(trailing: buttonDestination == nil ? nil : NavigationBarButton(image: buttonImage, destination: buttonDestination))
        }
        .accentColor(.title)
    }
}

// MARK: - View's extension

extension View {
    /**
     Add the content in a new navigation stack with a button in the navigation bar and the app's background.
     - parameter title: The navigation bar's title
     - parameter buttonImage: The button's image's system name.
     - parameter buttonDestination: The destination to reach when the button is hitten.
     - returns: The content in a new navigation stack with a button in the navigation bar and the app's background.
     */
    func inNavigationHome<T: View>(title: String, buttonImage: String, buttonDestination: T?) -> some View {
        modifier((InNavigationHome(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination)))
    }
    /**
     Add the content in a new navigation stack with the app's background.
     - parameter title: The navigation bar's title
     - returns: The content in a new navigation stack with the app's background.
     */
    func inNavigationHome(title: String) -> some View {
        let destination: Text? = nil
        return modifier(InNavigationHome(title: title, buttonImage: "", buttonDestination: destination))
    }
}


