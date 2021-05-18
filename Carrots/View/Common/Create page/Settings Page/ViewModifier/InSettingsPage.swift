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
    var confirmationIsDisabled: Bool?
    @EnvironmentObject var gameDoor: GameDoor
    @State var error: ApplicationErrors? = nil
    @State var showAlert: Bool = false
    private let helpText: String?
    @State var showHelp: Bool = false
    
    // MARK: - Init
    
    init(title: String, gameDoor: EnvironmentObject<GameDoor>, confirmationIsDisabled: Bool?, helpText: String?, confirmAction: @escaping () -> Void) {
        self.title = title
        self.confirmAction = confirmAction
        self.confirmationIsDisabled = confirmationIsDisabled
        self._gameDoor = gameDoor
        self.helpText = helpText
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            Divider()
            CommonHeightSpacer()
            if let text = helpText {
                HelpView(text: text, isShown: $showHelp, hasToBeShown: gameDoor.showHelp)
            }
            ScrollView(.vertical) {
                content
            }
            ConfirmButton(isDisabled: confirmationIsDisabled) {
                confirmAction()
                guard gameDoor.error == nil else {
                    showAlert = true
                    return
                }
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: title)
        .closeKeyboardOnTap()
        .alert(isPresented: $showAlert) {
            if let error = error {
                return Alert(
                    title: Text(error.userTitle),
                    message: Text(error.userMessage),
                    dismissButton: .default(Text("OK")))
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text("An error occurred."),
                    dismissButton: .default(Text("OK")))
            }
        }
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
    func inSettingsPage(_ title: String, gameDoor: EnvironmentObject<GameDoor>, confirmationButtonIsDisabled: Bool? = nil, helpText: String? = nil, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, gameDoor: gameDoor, confirmationIsDisabled: confirmationButtonIsDisabled, helpText: helpText, confirmAction: confirmAction))
    }
}
