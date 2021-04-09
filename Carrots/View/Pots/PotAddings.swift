//
//  PotAddings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotAddings: View {
    let pot: FakePot?
    @State var changeType: Int = 0
    @State var amount: String = ""
    var amountTitle: String {
        changeType == 0 ? "Amount to add" : "Amount to withdraw"
    }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text(pot?.owner?.name ?? "Common pot")
                .withTitleFont()
            Divider().padding()
            Picker(selection: $changeType, label: Text("Which modification do you want to do on this pot ?"), content: {
                Text("+ Add money")
                    .tag(0)
                    .withSimpleFont()
                Text("- Withdraw money")
                    .tag(1)
                    .withSimpleFont()
            })
            .pickerStyle(SegmentedPickerStyle())
            Divider().padding()
            TextField(amountTitle, text: $amount)
                .withSimpleFont()
                .keyboardType(.decimalPad)
            ConfirmButton {
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: "Pot modification")
    }
}
