//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct InDetailsPage<T: View>: ViewModifier {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Boolean indicating whether help's text is shown or not.
    @State private var showHelp: Bool = false
    /// The navigation's title.
    private let navigationTitle: String
    /// The title inside the page.
    private let specificTitle: String
    /// The view to call if user hit the edit button.
    private let destinationToModify: T
    /// The text to display if user asks for help.
    private let helpText: String?
    
    
    // MARK: - Init
    
    init(navigationTitle: String, specificTitle: String, destinationToModify: T, helpText: String?) {
        self.navigationTitle = navigationTitle
        self.specificTitle = specificTitle
        self.destinationToModify = destinationToModify
        self.helpText = helpText
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack {
            Divider()
            // Header of the page
            VStack {
                HStack {
                    // title
                    Text(specificTitle)
                        .withBigTitleFont()
                    // edit button
                    Image(systemName: "square.and.pencil")
                        .withNavigationLink(destination: destinationToModify)
                        .withLinkFont()
                }
                // help
                if let text = helpText {
                    HelpView(text: text, isShown: $showHelp)
                }
            }
            // Scrollview with modules
            Divider()
            ScrollView(.vertical) {
                // content = modules list
                content
            }
            Divider()
        }
        .inNavigationPageView(title: navigationTitle)
    }
}

// MARK: - View's extension

extension View {
    /**
     Take a details modules list as content and create a details page used to show details about an object.
     This ViewModifier has to be used on a VStack containing one or several Details Page's Modules. If the specified object can be modified, the *destinationToModify* parameter can contain the view used to modify it.
     - parameter navigationTitle: Title which will appear in the navigation bar.
     - parameter specificTitle: Title which will appear in the page, next to the modification button.
     - parameter destinationToModify: View used to modify the object (this view has to be a setting page).
     */
    func inDetailsPage<T: View>(navigationTitle: String, specificTitle: String, destinationToModify: T, helpText: String? = nil) -> some View {
        modifier(InDetailsPage(navigationTitle: navigationTitle, specificTitle: specificTitle, destinationToModify: destinationToModify, helpText: helpText))
    }
}




