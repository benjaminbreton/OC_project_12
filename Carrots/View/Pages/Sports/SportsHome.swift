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
        AppList(gameDoor.sports, placeHolder: """
                    No sports have been added.

                    To add a sport, press the + button on the top of the screen, and set sport's informations.
                    """)
            .inNavigationHome(
                title: "sports",
                buttonImage: "plus.circle",
                buttonDestination: SportSettings(sport: nil, name: "", icon: "A", unity: [], valueForOnePoint: ["", "", ""])
                    .environmentObject(gameDoor)
            )
    }
}




