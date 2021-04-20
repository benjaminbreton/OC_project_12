//
//  PerformanceSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct PerformanceSettings: View {
    let sportsArray: [FakeSport]
    let athleticsArray: [FakeAthletic]
    @State var selectedAthletics: [FakeAthletic] = []
    @State var selectedSport: [FakeSport] = []
    @State var value: [String] = ["0", "0", "0"]
    @State var valueEssai: String = ""
    @State var addToCommonPot: Bool = true
    var body: some View {
        VStack {
            CustomPicker(title: "Athletics", data: athleticsArray, selectedObjects: $selectedAthletics, maximumSelection: 0, lineCount: 2)
            CustomPicker(title: "Sport", data: sportsArray, selectedObjects: $selectedSport, maximumSelection: 1, lineCount: 1)
            SportValue(placeholder: "Choose a sport", unity: selectedSport.count == 1 ? selectedSport[0].unityInt16.sportUnityType : nil, value: $value)
            CustomToggleWithExplications(title: "Pot", question: "Add to common pot ? ", isOn: $addToCommonPot, explicationsIsOn: "Points will be added to common pot", explicationsIsOff: "Points will be added to athletics pots", textLines: 2)
        }
        .inSettingsPage("new performance", confirmAction: {
            
        })
    }

}
