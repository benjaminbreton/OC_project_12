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
    
    let unities: [Sport.UnityType] = [.count, .kilometers, .time]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        SettingsPageView(elements: [
                                .textField(text: "Name", value: $name),
                                .sportIconPicker(selected: $icon),
                                .genericPicker(allChoices: unities, selected: $unity, title: "Unity")],
                            title: name == "" ? "Sport creation" : "Sport settings")
    }
}
