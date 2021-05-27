//
//  SportsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportsHome: View {
    @EnvironmentObject var game: GameViewModel
    var body: some View {
        AppList(game.sports, placeholder: "sports.noSports".localized, helpText: "sportsList")
            .inNavigationHome(
                title: "sports.title".localized,
                buttonImage: "plus.circle",
                buttonDestination: SportSettings(sport: nil, name: "", icon: "A", unity: [], pointsConversion: ["", "", ""])
            )
    }
}




