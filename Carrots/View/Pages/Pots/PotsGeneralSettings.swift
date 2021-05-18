//
//  PotsGeneralSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotsGeneralSettings: View {
    @EnvironmentObject var gameDoor: GameDoor
    @State var date: Date
    @State var pointsForOneEuro: String
    @State var showHelp: Bool
    @State var arePointsWrong: Bool = false
    var confirmationButtonIsDisabled: Bool { arePointsWrong }
    var body: some View {
        VStack() {
            SettingsDatePicker(title: "Prevision date", date: $date, range: .afterToday, explanations: """
                                The application provides, for each pot, an expected amount on a certain date if athletics keep adding performances on the same rythm.
                                
                                You can set this date here.
                                """)
            SettingsTextfield(
                title: "Points for one euro",
                placeHolder: "points",
                value: $pointsForOneEuro,
                keyboard: .numberPad,
                explanations: """
        In this application, athletics can earn points by doing some sports performances.
        Points can be converted in euros in each pot.
        Set here the necessary number of points to earn one euro.
        """,
                isWrong: $arePointsWrong,
                limits: (minCount: 1, maxCount: 3),
                limitsExplanations: (minCount: "Enter a number.", maxCount: "The number has to be inferior than 1000"))
            SettingsCustomToggle(title: "Help", question: "Do you want help to be shown ?", isOn: $showHelp)
        }
        .inSettingsPage("general settings", gameDoor: _gameDoor, confirmationButtonIsDisabled: confirmationButtonIsDisabled) {
            gameDoor.updatePotsGeneralSettings(date: date, pointsForOneEuro: pointsForOneEuro, showHelp: showHelp)
        }
    }
}
