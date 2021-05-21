//
//  PerformanceSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct PerformanceSettings: View {
    @EnvironmentObject var gameDoor: GameDoor
    var sportsArray: [Sport] { gameDoor.sports }
    var athleticsArray: [Athletic] { gameDoor.athletics }
    @State var selectedAthletics: [Athletic] = []
    @State var selectedSport: [Sport] = []
    @State var value: [String] = ["", "", ""]
    @State var addToCommonPot: Bool = true
    /// Check if confirmation button has to be disabled.
    var confirmationButtonIsDisabled: Bool {
        // 3 conditions for the button to be disabled (only one can disable the button) :
        // 1. no athletics have been selected
        selectedAthletics.count == 0 ||
            // 2. no sport has been selected
            selectedSport.count != 1 ||
            // 3. the sport's unity type is not one shot and ...
            (selectedSport[0].unityInt16.sportUnityType != .oneShot &&
                (
                    // ... it's not time and the first value is empty or null
                    (selectedSport[0].unityInt16.sportUnityType != .time && Int(value[0]) ?? 0 == 0) ||
                        // ... it's time and all values are empty or null
                    (selectedSport[0].unityInt16.sportUnityType == .time && value.map({ Int($0) ?? 0 }).reduce(0, +) == 0)
                )
            )
    }
    var body: some View {
        VStack {
            SettingsCustomPicker(
                titleOne: "athletics.title.sing.maj".localized,
                titleMany: "athletics.title.maj".localized,
                data: athleticsArray,
                selectedObjects: $selectedAthletics,
                maximumSelection: 0,
                lineCount: 2)
            SettingsCustomPicker(
                titleOne: "sports.title.sing.maj".localized,
                titleMany: "sports.title.sing.maj".localized,
                data: sportsArray,
                selectedObjects: $selectedSport,
                maximumSelection: 1,
                lineCount: 1)
            SettingsSportValue(
                placeholder: "performances.settings.sportsInstructions".localized,
                unity: selectedSport.count == 1 ? selectedSport[0].unityInt16.sportUnityType : nil,
                valueForOnePoint: $value,
                caller: .performance,
                existingValueForOnePoint: selectedSport.count == 1 ? selectedSport[0].valueForOnePoint : nil)
            SettingsCustomToggleWithExplanations(
                title: "pots.title.maj".localized,
                question: "performances.settings.addPotQuestion".localized,
                isOn: $addToCommonPot,
                explanationsAreOn: "performances.settings.addExplanationsOn".localized,
                explanationsAreOff: "performances.settings.addExplanationsOff".localized,
                textLines: 2)
        }
        .inSettingsPage(
            "performances.new".localized,
            gameDoor: _gameDoor,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "performancesSettings") {
            guard selectedAthletics.count > 0, selectedSport.count == 1 else { return }
            gameDoor.addPerformance(sport: selectedSport[0], athletics: selectedAthletics, value: value, addToCommonPot: addToCommonPot)
        }
    }

}
