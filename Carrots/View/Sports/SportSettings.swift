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
    var body: some View {
        VStack {
            CustomTextfield(title: "Name", placeHolder: "Name", value: $name, keyboard: .default)
            CustomPicker(title: "Unity", data: Sport.UnityType.unities, selectedObjects: $unity, maximumSelection: 1, lineCount: 1)
            SportValue(placeholder: "Choose an unity", unity: unity.count == 1 ? unity[0] : nil, value: $valueForOnePoint)
            SportIconPicker(icon: $icon)
        }
        .inSettingsPage(name == "" ? "new sport":"\(name) settings") {
            
        }
    }
}
