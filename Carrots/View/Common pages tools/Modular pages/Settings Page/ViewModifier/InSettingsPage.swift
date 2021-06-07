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
    /// Boolean indicating whether a block alert is shown or not.
    @State private var showBlockAlert: Bool = false
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
    private var closeAfter: Bool { closeAfterMessage == nil }
    /// Message to display if the page does not have to be dismissed when confirmation button has been hitten.
    private var closeAfterMessage: String?
    /// Boolean indicating whether the settings page is the first tab's page or not.
    private var isHomePage: Bool
    
    
    
    
    
    // MARK: - Init
    
    init(title: String, game: EnvironmentObject<GameViewModel>, confirmationIsDisabled: Bool?, helpText: String?, closeAfterMessage: String?, isHomePage: Bool, confirmAction: @escaping () -> Void) {
        self.title = title
        self.confirmAction = confirmAction
        self.confirmationIsDisabled = confirmationIsDisabled
        self._game = game
        self.helpText = helpText
        self.closeAfterMessage = closeAfterMessage
        self.isHomePage = isHomePage
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
                    .frame(width: UIScreen.main.bounds.width)
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
                    // do not dismiss but show a block alert
                    showBlockAlert = true
                }
            }
        }
        .inSettingsNavigationHandler(
            title,
            isHomePage: isHomePage
        )
        .closeKeyboardOnTap()
        .alert(isPresented: $showAlert) {
            // show alert
            if let error = error {
                // in case of application error
                return Alert(
                    title: Text(error.userTitle),
                    message: Text(error.userMessage),
                    dismissButton: .default(Text("OK")))
            } else {
                // default case
                return Alert(
                    title: Text("Error"),
                    message: Text("An error occurred."),
                    dismissButton: .default(Text("OK")))
            }
        }
        .withSettingsBlockAlert(
            closeAfterMessage,
            alertIsShown: $showBlockAlert
        )
    }
}

// MARK: - Block alert

/**
 Create a view in which a block containing an alert can be displayed over the specified content for 3 seconds and then disappear.
 */
fileprivate struct WithSettingsBlockAlert: ViewModifier {
    
    // MARK: - Properties
    
    /// An observed object containing a timer to dismiss the alert.
    @ObservedObject private var blockTimer: SettingsBlockAlertTimer
    /// Boolean indicating whether the alert is shown or not.
    @Binding var alertIsShown: Bool
    /// The message to display.
    private let message: String?
    
    // MARK: - Init
    
    init(_ message: String?, alertIsShown: Binding<Bool>) {
        self.message = message
        self._alertIsShown = alertIsShown
        self.blockTimer = SettingsBlockAlertTimer(alertIsShown.wrappedValue)
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        ZStack {
            // the page
            content
            // the alert block
            if let message = message, alertIsShown {
                ZStack {
                    // block's background
                    RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                        .foregroundColor(.alertBlockBackground)
                    // block's shape
                    RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                        .stroke(lineWidth: ViewCommonSettings().commonSizeBase / 2)
                        .foregroundColor(.alertBlockShape)
                    // block's content
                    VStack {
                        Image(systemName: "checkmark")
                            .withAlertBlockImageFont()
                        VerticalSpacer()
                        Text(message)
                            .withAlertBlockTextFont()
                        
                    }
                    .inRectangle(.center)
                }
                .frame(width: ViewCommonSettings().commonSizeBase * 20)
                .fixedSize(horizontal: true, vertical: true)
                .onAppear {
                    // start the timer used to dismiss the alert
                    blockTimer.start()
                }
            }
        }
        .onReceive(blockTimer.$alertIsShown) { newValue in
            // when the timer change its value, hide alert if the new value is false
            if !newValue { alertIsShown = newValue }
        }
    }
    
    // MARK: - The timer
    
    /**
     The timer used to dismiss the alert.
     */
    class SettingsBlockAlertTimer: ObservableObject {
        
        // MARK: - Properties
        
        /// Boolean indicating whether the alert is shown or not.
        @Published var alertIsShown: Bool
        /// The timer itself.
        private var timer: Timer?
        
        // MARK: - Init
        
        init(_ alertIsShown: Bool) {
            self.alertIsShown = alertIsShown
            let notification = Notification.Name("hideAlert")
            NotificationCenter.default.addObserver(self, selector: #selector(hideAlert), name: notification, object: nil)
        }
        
        // MARK: - Methods
        
        /**
         Start the timer.
         */
        func start() {
            alertIsShown = true
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(notify), userInfo: nil, repeats: false)
        }
        /**
         Notify that the timer has been ended.
         */
        @objc
        private func notify() {
            let notificationName = Notification.Name("hideAlert")
            let notification = Notification(name: notificationName)
            NotificationCenter.default.post(notification)
        }
        /**
         Hide alert.
         */
        @objc
        private func hideAlert() {
            alertIsShown = false
        }
    }
}

// MARK: - Navigation handler

/**
 Check if the settings page is the first page in the tab and place it in a navigationPage or a navigationHome.
 */
fileprivate struct InSettingsNavigationHandler: ViewModifier {
    
    // MARK: - Properties
    
    /// Boolean indicating whether the settings page is the first tab's page or not.
    private let isHomePage: Bool
    /// Title to display in the navigation bar.
    private let title: String
    
    // MARK: - Init
    
    init(isHomePage: Bool, title: String) {
        self.isHomePage = isHomePage
        self.title = title
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        Group {
            switch isHomePage {
            case true:
                content.inNavigationHome(title: title)
            case false:
                content.inNavigationPage(title)
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
     - parameter isHomePage: Boolean indicating whether the settings page is the first tab's page or not.
     - parameter confirmAction: Action to perform if the confirmation button is hitten.
     - returns: The created settings page.
     */
    func inSettingsPage(_ title: String, game: EnvironmentObject<GameViewModel>, confirmationButtonIsDisabled: Bool? = nil, helpText: String? = nil, closeAfterMessage: String? = nil, isHomePage: Bool = false, confirmAction: @escaping () -> Void) -> some View {
        modifier(InSettingsPage(title: title, game: game, confirmationIsDisabled: confirmationButtonIsDisabled, helpText: helpText, closeAfterMessage: closeAfterMessage, isHomePage: isHomePage, confirmAction: confirmAction))
    }
    /**
     Check if the settings page is the first page in the tab and place it in a navigationPage or a navigationHome.
     - parameter title: The navigation bar's title.
     - parameter isHomePage: Boolean indicating whether the settings page is the first tab's page or not.
     */
    fileprivate func inSettingsNavigationHandler(_ title: String, isHomePage: Bool) -> some View {
        modifier(InSettingsNavigationHandler(isHomePage: isHomePage, title: title))
    }
    /**
     Create a view in which a block containing an alert can be displayed over the specified content for 3 seconds and then disappear.
     - parameter message: The message to display.
     - parameter alertIsShown: Boolean indicating whether the alert is shown or not.
     - returns: The view in which a block containing an alert can be displayed over the specified content for 3 seconds and then disappear.
     */
    fileprivate func withSettingsBlockAlert(_ message: String?, alertIsShown: Binding<Bool>) -> some View {
        modifier(WithSettingsBlockAlert(message, alertIsShown: alertIsShown))
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
                .inButton(isDisabled: isDisabled) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    action()
                }
            VerticalSpacer()
            Divider()
        }
    }
}
