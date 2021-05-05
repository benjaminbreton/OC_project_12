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
    var confirmationIsDisabled: Binding<Bool>?
    
    // MARK: - Init
    
    init(title: String, confirmationIsDisabled: Binding<Bool>?, confirmAction: @escaping () -> Void) {
        self.title = title
        self.confirmAction = confirmAction
        self.confirmationIsDisabled = confirmationIsDisabled
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            Divider()
            CommonHeightSpacer()
            ScrollView(.vertical) {
                content
            }
            ConfirmButton(isDisabled: confirmationIsDisabled) {
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
    func inSettingsPage(_ title: String, confirmationButtonIsDisabled: Binding<Bool>? = nil, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, confirmationIsDisabled: confirmationButtonIsDisabled, confirmAction: confirmAction))
    }
}
