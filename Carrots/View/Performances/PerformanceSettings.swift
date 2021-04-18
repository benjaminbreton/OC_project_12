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
    var body: some View {
        VStack {
            CustomPicker(title: "Athletics", data: athleticsArray, selectedObjects: $selectedAthletics, maximumSelection: 0, lineCount: 2)
            CustomPicker(title: "Sport", data: sportsArray, selectedObjects: $selectedSport, maximumSelection: 1, lineCount: 1)
            SportValue(sport: $selectedSport, value: $value)
 
        }
        .inSettingsPage("New performance", confirmAction: {
            
        })
    }

}
