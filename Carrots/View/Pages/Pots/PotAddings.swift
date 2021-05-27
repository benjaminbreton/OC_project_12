//
//  PotAddings.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
/**
 Settings page used to add or withdraw money from a pot.
 */
struct PotAddings: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// The selected operation : add or withdraw.
    @State private var selectedOperation: Int = 0
    /// The amount to add or withdraw.
    @State private var amount: String = ""
    /// Boolean indicating whether an error has been detected or not.
    @State private var amountIsWrong: Bool = false
    /// Pot receiving the changes.
    private let pot: Pot?
    /// Boolean indicating whether an error has been detected or not, so, whether the confirmation button has be disabled or not.
    private var confirmationButtonIsDisabled: Bool { amountIsWrong }
    /// Placeholder to display in the amount's textfield.
    private var placeholder: String {
        selectedOperation == 0 ? "pots.addings.addPlaceholder".localized : "pots.addings.withdrawPlaceholder".localized
    }
    
    // MARK: - Init
    
    init(_ pot: Pot?) {
        self.pot = pot
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module to choose an operation
            SettingsSegmentedPicker(
                $selectedOperation,
                title: "pots.addings.modificationTitle".localized,
                instructions: "pots.addings.modificationInstructions".localized,
                possibilities: ["pots.addings.addTitle".localized, "pots.addings.withdrawTitle".localized]
            )
            // module to choose an amount
            SettingsTextfield(
                title: "pots.addings.amountTitle".localized,
                placeholder: placeholder,
                value: $amount,
                keyboard: .decimalPad,
                isWrong: $amountIsWrong,
                limits: (minCount: 1, maxCount: nil),
                limitsExplanations: (minCount: "pots.addings.amountLimitMin".localized, maxCount: nil)
            )
        }
        .inSettingsPage(
            "\(pot?.description ?? "all.noName".localized)",
            game: _game,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "potsAddings"
        ) {
            // confirmation button's action
            game.changeMoney(for: pot?.owner, amount: amount, operation: selectedOperation)
        }
    }
}
