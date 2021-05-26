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
    @EnvironmentObject var game: GameViewModel
    @State var error: ApplicationErrors? = nil
    @State var showAlert: Bool = false
    private let helpText: String?
    @State var showHelp: Bool = false
    var closeAfter: Bool
    var closeAfterMessage: (title: String, message: String)?
    // MARK: - Init
    
    init(title: String, game: EnvironmentObject<GameViewModel>, confirmationIsDisabled: Bool?, helpText: String?, closeAfterMessage: (title: String, message: String)?, confirmAction: @escaping () -> Void) {
        self.title = title
        self.confirmAction = confirmAction
        self.confirmationIsDisabled = confirmationIsDisabled
        self._game = game
        self.helpText = helpText
        self.closeAfter = closeAfterMessage == nil
        self.closeAfterMessage = closeAfterMessage
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            Divider()
            CommonHeightSpacer()
            if let text = helpText {
                HelpView(text: text, isShown: $showHelp)
            }
            ScrollView(.vertical) {
                content
            }
            ConfirmButton(isDisabled: confirmationIsDisabled) {
                error = nil
                confirmAction()
                error = game.error
                guard error == nil else {
                    showAlert = true
                    return
                }
                if closeAfter {
                    mode.wrappedValue.dismiss()
                } else {
                    showAlert = true
                }
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
            } else if let tuple = closeAfterMessage {
                return Alert(
                    title: Text(tuple.title),
                    message: Text(tuple.message),
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
    func inSettingsPage(_ title: String, game: EnvironmentObject<GameViewModel>, confirmationButtonIsDisabled: Bool? = nil, helpText: String? = nil, closeAfterMessage: (title: String, message: String)? = nil, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, game: game, confirmationIsDisabled: confirmationButtonIsDisabled, helpText: helpText, closeAfterMessage: closeAfterMessage, confirmAction: confirmAction))
    }
}
