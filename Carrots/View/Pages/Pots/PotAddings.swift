//
//  PotAddings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotAddings: View {
    @EnvironmentObject var gameDoor: GameDoor
    let pot: Pot?
    @State var selection: Int = 0
    @State var amount: String = ""
    @State var amountIsWrong: Bool = false
    var confirmationButtonIsDisabled: Bool { amountIsWrong }
    var placeHolder: String {
        selection == 0 ? "Amount to add" : "Amount to withdraw"
    }
    
    var body: some View {
        VStack {
            SettingsSegmentedPicker(title: "Modification type", selection: $selection, instructions: "Choose the modification to do", possibilities: ["+ add money", "- withdraw money"])
            SettingsTextfield(title: "Amount", placeHolder: placeHolder, value: $amount, keyboard: .decimalPad, isWrong: $amountIsWrong, limits: (minCount: 1, maxCount: nil), limitsExplanations: (minCount: "You have to choose an amount", maxCount: nil))
        }
        .inSettingsPage("\(pot?.description ?? "No name")", gameDoor: _gameDoor, confirmationButtonIsDisabled: confirmationButtonIsDisabled) {
            gameDoor.changeMoney(for: pot?.owner, amount: amount, operation: selection)
        }
    }
}
