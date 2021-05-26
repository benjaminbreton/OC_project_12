//
//  SportsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportsHome: View {
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        AppList(gameDoor.sports, placeHolder: "sports.noSports".localized, helpText: "sportsList")
            .inNavigationHome(
                title: "sports.title".localized,
                buttonImage: "plus.circle",
                buttonDestination: SportSettings(sport: nil, name: "", icon: "A", unity: [], pointsConversion: ["", "", ""])
            )
    }
}




