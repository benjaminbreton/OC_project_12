//
//  PotsGeneralSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct GeneralSettings: View {
    @EnvironmentObject var game: GameViewModel
    @State var date: Date
    /// Necessary number of points to get one money's unity.
    @State var moneyConversion: String
    @State var showHelp: Bool
    @State var arePointsWrong: Bool = false
    var confirmationButtonIsDisabled: Bool { arePointsWrong }
    private var moneyName: String { "\(Locale.current.localizedString(forCurrencyCode: Locale.current.currencyCode ?? "") ?? "euro")" }
    var body: some View {
        VStack() {
            SettingsDatePicker(title: "settings.date.title".localized, date: $date, range: .afterToday, explanations: "settings.date.explanations".localized)
            SettingsTextfield(
                title: "settings.conversion.title".localized,
                placeHolder: "points.title".localized,
                value: $moneyConversion,
                keyboard: .numberPad,
                explanations: "\("settings.conversion.explanations1".localized)\(moneyName)\("settings.conversion.explanations2".localized)\(moneyName).",
                isWrong: $arePointsWrong,
                limits: (minCount: 1, maxCount: 3),
                limitsExplanations: (minCount: "settings.conversion.limitExplanationsMin".localized, maxCount: "settings.conversion.limitExplanationsMax".localized))
            SettingsCustomToggle(title: "settings.help.title".localized, question: "settings.help.question".localized, isOn: $showHelp)
        }
        .inSettingsPage("settings.title".localized, game: _game, confirmationButtonIsDisabled: confirmationButtonIsDisabled, closeAfterMessage: (title: "settings.alert.title".localized, message: "settings.alert.message".localized)) {
            game.modifySettings(predictionDate: date, moneyConversion: moneyConversion, showHelp: showHelp)
        }
        .inNavigationHome(title: "settings.title".localized)
    }
}
