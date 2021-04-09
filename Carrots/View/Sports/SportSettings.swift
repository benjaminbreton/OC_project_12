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
    
    @State var unity: Sport.UnityType
    let unities: [Sport.UnityType] = [.count, .kilometers, .time]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Divider()
            Text("Name")
                .withTitleFont()
            TextField("Name", text: $name)
                .withBigSimpleFont()
            Divider()
            Text("Icon")
                .withTitleFont()
            SportIconScrollView(selection: Int(sport?.icon ?? 0))
            Divider()
            Text("Unity")
                .withTitleFont()
            Picker("Please choose an unity", selection: $unity) {
                ForEach(unities, id: \.self) {
                    Text($0.description)
                        .withSimpleFont()
                }
                
            }
            ConfirmButton {
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: sport == nil ? "Create sport" : "Sport settings")
    }
}
