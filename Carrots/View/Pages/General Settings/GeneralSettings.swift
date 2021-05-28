//
//  PotsGeneralSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
/**
 Settings page used to change applications settings, aka UserDefaults.
 */
struct GeneralSettings: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Settings prediction date.
    @State private var date: Date = Date()
    /// Settings necessary number of points to get one money's unity.
    @State private var moneyConversion: String = "0"
    /// Settings boolean indicating whether help is enabled or not.
    @State private var showHelp: Bool = true
    /// Boolean indicating whether money conversion's textfield contains an error or not.
    @State private var arePointsWrong: Bool = false
    /// Boolean indicating whether an error has been detected or not, so, whether the confirmation button has be disabled or not.
    private var confirmationButtonIsDisabled: Bool { arePointsWrong }
    /// The locale currency's name.
    private var moneyName: String { "\(Locale.current.localizedString(forCurrencyCode: Locale.current.currencyCode ?? "") ?? "euro")" }
    
    // MARK: - Body
    
    var body: some View {
        VStack() {
            // prediction date module
            SettingsDatePicker(
                title: "settings.date.title".localized,
                date: $date,
                range: .afterToday,
                explanations: "settings.date.explanations".localized)
            // money conversion module
            SettingsTextfield(
                title: "settings.conversion.title".localized,
                placeholder: "points.title".localized,
                value: $moneyConversion,
                keyboard: .numberPad,
                explanations: "\("settings.conversion.explanations1".localized)\(moneyName)\("settings.conversion.explanations2".localized)\(moneyName).",
                isWrong: $arePointsWrong,
                limits: (minCount: 1, maxCount: 3),
                limitsExplanations: (minCount: "settings.conversion.limitExplanationsMin".localized, maxCount: "settings.conversion.limitExplanationsMax".localized))
            // help module
            SettingsCustomToggle(
                title: "settings.help.title".localized,
                question: "settings.help.question".localized,
                isOn: $showHelp)
        }
        .onAppear {
            // set values
            self.date = game.predictionDate
            self.moneyConversion = game.moneyConversion
            self.showHelp = game.showHelp
        }
        .inSettingsPage(
            "settings.title".localized,
            game: _game,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            closeAfterMessage: "settings.alert.message".localized,
            isHomePage: true
        ) {
            // confirmation button's action
            game.modifySettings(predictionDate: date, moneyConversion: moneyConversion, showHelp: showHelp)
        }
    }
}
