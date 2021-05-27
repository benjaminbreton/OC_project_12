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
    
    /// Used to dismiss page.
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Error getted from the ViewModel.
    @State private var error: ApplicationErrors? = nil
    /// Boolean indicating whether an alert has to be displayed or not (due to an error).
    @State private var showAlert: Bool = false
    /// Boolean indicating whether help texts have to be shown or not.
    @State private var showHelp: Bool = false
    /// Title to display in the navigation bar.
    private let title: String
    /// Action to perform if the confirmation button is hitten.
    private let confirmAction: () -> Void
    /// Boolean indicating whether the confirmation button is disabled or not.
    private var confirmationIsDisabled: Bool?
    /// The text to display if user asked for help.
    private let helpText: String?
    /// Boolean indicating whether the page has be dismissed when the confirmation button has been hitten or not.
    private var closeAfter: Bool
    /// Message to display if the page does not have to be dismissed when confirmation button has been hitten.
    private var closeAfterMessage: (title: String, message: String)?
    
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
            VerticalSpacer()
            // help text
            if let text = helpText {
                HelpView(text: text, isShown: $showHelp)
            }
            // content containing settings modules
            ScrollView(.vertical) {
                content
            }
            // confirmation button
            ConfirmButton(isDisabled: confirmationIsDisabled) {
                error = nil
                // perform action
                confirmAction()
                // check if an error occurred
                error = game.error
                // if error : show alert
                guard error == nil else {
                    showAlert = true
                    return
                }
                if closeAfter {
                    // dismiss
                    mode.wrappedValue.dismiss()
                } else {
                    // do not dismiss but show an alert
                    showAlert = true
                }
            }
        }
        .inNavigationPage(title)
        .closeKeyboardOnTap()
        .alert(isPresented: $showAlert) {
            // show alert
            if let error = error {
                // in case of error
                return Alert(
                    title: Text(error.userTitle),
                    message: Text(error.userMessage),
                    dismissButton: .default(Text("OK")))
            } else if let tuple = closeAfterMessage {
                // in case of success with no dismiss
                return Alert(
                    title: Text(tuple.title),
                    message: Text(tuple.message),
                    dismissButton: .default(Text("OK")))
            } else {
                // default case
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
     - parameter title: Title to display in the navigation bar.
     - parameter confirmationButtonIsDisabled: Boolean indicating whether the confirmation button is disabled or not.
     - parameter helpText: The text to display if user asked for help.
     - parameter closeAfterMessage: Tuple containing the *title* and the *message* to display if the page does not have to be dismissed when confirmation button has been hitten.
     - parameter confirmAction: Action to perform if the confirmation button is hitten.
     - returns: The created settings page.
     */
    func inSettingsPage(_ title: String, game: EnvironmentObject<GameViewModel>, confirmationButtonIsDisabled: Bool? = nil, helpText: String? = nil, closeAfterMessage: (title: String, message: String)? = nil, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, game: game, confirmationIsDisabled: confirmationButtonIsDisabled, helpText: helpText, closeAfterMessage: closeAfterMessage, confirmAction: confirmAction))
    }
}

// MARK: - Confirm button

/**
 Button used in a settings page to confirm entries.
 */
fileprivate struct ConfirmButton: View {
    
    // MARK: - Properties
    
    /// Action to perform.
    private let action: () -> Void
    /// Boolean indicating whether the button is disabled or not.
    private var isDisabled: Bool?
    
    // MARK: - Init
    
    init(isDisabled: Bool? = nil, action: @escaping () -> Void) {
        self.action = action
        self.isDisabled = isDisabled
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Divider()
            VerticalSpacer()
            Text("confirmation.title".localized)
                .inButton(isDisabled: isDisabled, action: action)
            VerticalSpacer()
            Divider()
        }
    }
}
