//
//  AthleticSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticSettings: View {
    let athletic: FakeAthletic?
    @State var name: String
    @State var image: UIImage?
    var body: some View {
        VStack {
            SettingsTextfield(title: "Name", placeHolder: "Name", value: $name, keyboard: .default)
            SettingsAthleticImagePicker(image: $image)
        }
        .inSettingsPage(name == "" ? "New athletic":"\(name) settings", confirmAction: {
            
        })
    }
    
}
