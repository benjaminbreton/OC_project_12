//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct PotsHome: View {
    @EnvironmentObject var game: GameViewModel
    var body: some View {
        let athleticsPots = game.athletics.map({ $0.pot ?? Pot() })
        return VStack {
            AppList(athleticsPots,
                    placeHolder: "pots.noAthletics".localized,
                    commonPot: game.commonPot,
                    title: "pots.athleticsPots".localized,
                    helpText: "potsList")
            PotsWarning()
        }
        .inNavigationHome(title: "pots.title".localized)
    }
}
