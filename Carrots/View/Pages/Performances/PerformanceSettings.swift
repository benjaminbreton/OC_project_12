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
    @State var value: [String] = ["0", "0", "0"]
    @State var addToCommonPot: Bool = true
    var body: some View {
        VStack {
            SettingsCustomPicker(title: "Athletics", data: athleticsArray, selectedObjects: $selectedAthletics, maximumSelection: 0, lineCount: 2)
            SettingsCustomPicker(title: "Sport", data: sportsArray, selectedObjects: $selectedSport, maximumSelection: 1, lineCount: 1)
            SettingsSportValue(placeholder: "Choose a sport", unity: selectedSport.count == 1 ? selectedSport[0].unityInt16.sportUnityType : nil, valueForOnePoint: $value, caller: .performance, existingValueForOnePoint: selectedSport.count == 1 ? selectedSport[0].valueForOnePoint : nil)
            SettingsCustomToggleWithExplications(title: "Pot", question: "Add to common pot ? ", isOn: $addToCommonPot, explicationsIsOn: "Points will be added to common pot", explicationsIsOff: "Points will be added to athletics pots", textLines: 2)
        }
        .inSettingsPage("new performance", gameDoor: _gameDoor, confirmAction: {
            guard selectedAthletics.count > 0, selectedSport.count == 1 else { return }
            gameDoor.addPerformance(sport: selectedSport[0], athletics: selectedAthletics, value: value, addToCommonPot: addToCommonPot)
        })
    }

}
