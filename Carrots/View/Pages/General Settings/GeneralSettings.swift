//
//  PotsGeneralSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct GeneralSettings: View {
    @EnvironmentObject var gameDoor: GameDoor
    @State var date: Date
    @State var pointsForOneEuro: String
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
                value: $pointsForOneEuro,
                keyboard: .numberPad,
                explanations: "\("settings.conversion.explanations1".localized)\(moneyName)\("settings.conversion.explanations2".localized)\(moneyName).",
                isWrong: $arePointsWrong,
                limits: (minCount: 1, maxCount: 3),
                limitsExplanations: (minCount: "Enter a number.", maxCount: "The number has to be inferior than 1000"))
            SettingsCustomToggle(title: "settings.help.title".localized, question: "settings.help.question".localized, isOn: $showHelp)
        }
        .inSettingsPage("settings.navigationTitle".localized, gameDoor: _gameDoor, confirmationButtonIsDisabled: confirmationButtonIsDisabled, closeAfterMessage: (title: "settings.alert.title".localized, message: "settings.alert.message".localized)) {
            gameDoor.updatePotsGeneralSettings(date: date, pointsForOneEuro: pointsForOneEuro, showHelp: showHelp)
        }
        .inNavigationHome(title: "settings.navigationTitle".localized)
    }
}
