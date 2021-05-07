//
//  SportSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportSettings: View {
    @EnvironmentObject var gameDoor: GameDoor
    let sport: Sport?
    @State var name: String
    @State var icon: String
    @State var unity: [Sport.UnityType] = []
    @State var valueForOnePoint: [String] = ["0", "0", "0"]
    let unities: [Sport.UnityType] = [.count, .distance, .time]
    var body: some View {
        VStack {
            SettingsTextfield(title: "Name", placeHolder: "Name", value: $name, keyboard: .default)
            SettingsCustomPicker(title: "Unity", data: unities, selectedObjects: $unity, maximumSelection: 1, lineCount: 1)
            SettingsSportValue(placeholder: "Choose an unity", unity: unity.count == 1 ? unity[0] : nil, value: $valueForOnePoint)
            SettingsSportIconPicker(icon: $icon)
        }
        .inSettingsPage(name == "" ? "new sport":"\(name) settings", gameDoor: _gameDoor) {
            guard unity.count == 1 else { return }
            if let sport = sport {
                gameDoor.update(sport, name: name, icon: icon, unityType: unity[0].int16, valueForOnePoint: valueForOnePoint)
            } else {
                gameDoor.addSport(name: name, icon: icon, unityType: unity[0].int16, valueForOnePoint: valueForOnePoint)
            }
        }
    }
}
