//
//  SportSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportSettings: View {
    let sport: FakeSport?
    
    @State var name: String
    @State var icon: Int
    @State var unity: Sport.UnityType
    @State var valueForOnePoint: [String]
    
    let unities: [Sport.UnityType] = [.count, .kilometers, .time]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        SettingsPageView(elements: [
                            .textField(text: "Name", value: $name, keyboardType: .default),
                                .sportIconPicker(selected: $icon),
                                //.sportUnityPicker(allChoices: unities, selected: $unity),
                            .sportUnityValue(selected: unity, valueForOnePoint: $valueForOnePoint)],
                         title: name == "" ? "Sport creation" : "Sport settings") {
            
        }
    }
}
