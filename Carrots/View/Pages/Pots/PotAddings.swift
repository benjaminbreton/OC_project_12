//
//  PotAddings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotAddings: View {
    @EnvironmentObject var game: GameViewModel
    let pot: Pot?
    @State var selection: Int = 0
    @State var amount: String = ""
    @State var amountIsWrong: Bool = false
    var confirmationButtonIsDisabled: Bool { amountIsWrong }
    var placeholder: String {
        selection == 0 ? "pots.addings.addPlaceholder".localized : "pots.addings.withdrawPlaceholder".localized
    }
    
    var body: some View {
        VStack {
            SettingsSegmentedPicker($selection,
                                    title: "pots.addings.modificationTitle".localized,
                                    instructions: "pots.addings.modificationInstructions".localized,
                                    possibilities: ["pots.addings.addTitle".localized, "pots.addings.withdrawTitle".localized])
            SettingsTextfield(title: "pots.addings.amountTitle".localized, placeholder: placeholder, value: $amount, keyboard: .decimalPad, isWrong: $amountIsWrong, limits: (minCount: 1, maxCount: nil), limitsExplanations: (minCount: "pots.addings.amountLimitMin".localized, maxCount: nil))
        }
        .inSettingsPage("\(pot?.description ?? "all.noName".localized)",
                        game: _game,
                        confirmationButtonIsDisabled: confirmationButtonIsDisabled,
                        helpText: "potsAddings") {
            game.changeMoney(for: pot?.owner, amount: amount, operation: selection)
        }
    }
}
