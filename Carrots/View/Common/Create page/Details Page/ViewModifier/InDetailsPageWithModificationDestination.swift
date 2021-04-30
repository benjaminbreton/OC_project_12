//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI

// MARK: - ViewModifier without modification page

fileprivate struct InDetailsPageWithoutModificationDestination: ViewModifier {
    
    // MARK: - Property
    
    private let title: String
    
    // MARK: - Init
    
    init(title: String) {
        self.title = title
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack {
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageView(title: title)
    }
}

// MARK: - ViewModifier with modification page

fileprivate struct InDetailsPageWithModificationDestination<T: View>: ViewModifier {
    
    // MARK: - Properties
    
    private let genericTitle: String
    private let specificTitle: String
    private let destinationToModify: T
    
    // MARK: - Init
    
    init(genericTitle: String, specificTitle: String, destinationToModify: T) {
        self.genericTitle = genericTitle
        self.specificTitle = specificTitle
        self.destinationToModify = destinationToModify
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack {
            Divider()
            HStack {
                Text(specificTitle)
                    .withBigTitleFont()
                Image(systemName: "square.and.pencil")
                    .withNavigationLink(destination: destinationToModify)
                    .withLinkFont()
            }
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageView(title: genericTitle)
    }
}

// MARK: - View's extension

extension View {
    /**
     Used to show details about an object.
     This ViewModifier has to be used on a VStack containing one or several Details Page's Modules. If the specified object can be modified, the *destinationToModify* parameter can contain the view used to modify it.
     - parameter genericTitle: Title which will appear in the navigation bar.
     - parameter specificTitle: Title which will appear in the page, next to the modification button.
     - parameter destinationToModify: View used to modify the object (this view has to be a setting page).
     */
    func inDetailsPage<T: View>(genericTitle: String, specificTitle: String, destinationToModify: T) -> some View {
        modifier(InDetailsPageWithModificationDestination(genericTitle: genericTitle, specificTitle: specificTitle, destinationToModify: destinationToModify))
    }
    /**
     Used to show details about an object.
     This ViewModifier has to be used on a VStack containing one or several Details Page Modules. If the specified object can be modified, choose the other method containing the *destinationToModify* parameter.
     - parameter genericTitle: Title which will appear in the navigation bar.
     */
    func inDetailsPage(genericTitle: String) -> some View {
        modifier(InDetailsPageWithoutModificationDestination(title: genericTitle))
    }
}




