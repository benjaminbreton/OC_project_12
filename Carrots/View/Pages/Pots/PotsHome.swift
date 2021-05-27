//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
/**
 First page of pots tab: display the pots list.
 */
struct PotsHome: View {
    
    // MARK: - Property
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        // get all athletics pots
        let athleticsPots = game.athletics.map({ $0.pot ?? Pot() })
        // return the list
        return VStack {
            // the list
            AppList(
                athleticsPots,
                placeholder: "pots.noAthletics".localized,
                commonPot: game.commonPot,
                title: "pots.athleticsPots".localized,
                helpText: "potsList"
            )
            // the pots amount warning
            PotsWarning()
        }
        .inNavigationHome(title: "pots.title".localized)
    }
}
