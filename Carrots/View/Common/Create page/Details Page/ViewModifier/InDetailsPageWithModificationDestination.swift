//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct InDetailsPageWithModificationDestination<T: View>: ViewModifier {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    @State private var showHelp: Bool = false
    private let genericTitle: String
    private let specificTitle: String
    private let destinationToModify: T
    private let helpText: String?
    
    
    // MARK: - Init
    
    init(genericTitle: String, specificTitle: String, destinationToModify: T, helpText: String?) {
        self.genericTitle = genericTitle
        self.specificTitle = specificTitle
        self.destinationToModify = destinationToModify
        self.helpText = helpText
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack {
            Divider()
            VStack {
                HStack {
                    Text(specificTitle)
                        .withBigTitleFont()
                    Image(systemName: "square.and.pencil")
                        .withNavigationLink(destination: destinationToModify)
                        .withLinkFont()
                }
                if let text = helpText {
                    HelpView(text: text, isShown: $showHelp, hasToBeShown: game.showHelp)
                }
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
    func inDetailsPage<T: View>(genericTitle: String, specificTitle: String, destinationToModify: T, helpText: String? = nil) -> some View {
        modifier(InDetailsPageWithModificationDestination(genericTitle: genericTitle, specificTitle: specificTitle, destinationToModify: destinationToModify, helpText: helpText))
    }
}




