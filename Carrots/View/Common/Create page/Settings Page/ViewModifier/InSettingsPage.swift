//
//  InSettingsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct InSettingsPage: ViewModifier {
    
    // MARK: - Properties
    
    private let title: String
    private let confirmAction: () -> Void
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: - Init
    
    init(title: String, confirmAction: @escaping () -> Void) {
        self.title = title
        self.confirmAction = confirmAction
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            Divider()
            ScrollView(.vertical) {
                content
            }
            ConfirmButton {
                confirmAction()
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: title)
        .closeKeyboardOnTap()
    }
}

// MARK: - View's extension

extension View {
    /**
     Used to set an object (new creation or modification of an existing one).
     This ViewModifier has to be used on a VStack containing one or several Settings Page's Modules.
     - parameter title: Title which will appear in the navigation bar.
     - parameter confirmAction: Actions to do when user confirm its choices.
     */
    func inSettingsPage(_ title: String, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, confirmAction: confirmAction))
    }
}
