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
    @State var confirmationButtonIsDisabled: Bool = false
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
                isWrong: $confirmationButtonIsDisabled,
                limits: (minCount: 1, maxCount: 3),
                limitsExplanations: (minCount: "Enter a number.", maxCount: "The number has to be inferior than 1000"))
        }
        .inSettingsPage("general settings", gameDoor: _gameDoor, confirmationButtonIsDisabled: $confirmationButtonIsDisabled) {
            gameDoor.updatePotsGeneralSettings(date: date, pointsForOneEuro: pointsForOneEuro)
        }
    }
}
