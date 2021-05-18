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
                title: "Athletics",
                data: athleticsArray,
                selectedObjects: $selectedAthletics,
                maximumSelection: 0,
                lineCount: 2)
            SettingsCustomPicker(
                title: "Sport",
                data: sportsArray,
                selectedObjects: $selectedSport,
                maximumSelection: 1,
                lineCount: 1)
            SettingsSportValue(
                placeholder: "Choose a sport",
                unity: selectedSport.count == 1 ? selectedSport[0].unityInt16.sportUnityType : nil,
                valueForOnePoint: $value,
                caller: .performance,
                existingValueForOnePoint: selectedSport.count == 1 ? selectedSport[0].valueForOnePoint : nil)
            SettingsCustomToggleWithExplanations(
                title: "Pot",
                question: "Add to common pot ? ",
                isOn: $addToCommonPot,
                explanationsAreOn: "Points will be added to common pot",
                explanationsAreOff: "Points will be added to athletics pots",
                textLines: 2)
        }
        .inSettingsPage(
            "new performance",
            gameDoor: _gameDoor,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: """
            To add a performance :

            Choose athletics who did it. You can add several athletics. To add athletics : select an athletic on the list and click on the plus button.

            Choose performance's sport.

            Set the realised performance to convert it on points.

            Finally, choose a pot to add points : common pot, or athletics pots.
            """) {
            guard selectedAthletics.count > 0, selectedSport.count == 1 else { return }
            gameDoor.addPerformance(sport: selectedSport[0], athletics: selectedAthletics, value: value, addToCommonPot: addToCommonPot)
        }
    }

}
