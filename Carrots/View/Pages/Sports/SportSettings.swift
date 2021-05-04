//
//  SportSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportSettings: View {
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
        .inSettingsPage(name == "" ? "new sport":"\(name) settings") {
            
        }
    }
}
