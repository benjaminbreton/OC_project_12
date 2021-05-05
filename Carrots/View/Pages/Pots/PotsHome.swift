//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct PotsHome: View {
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        let athleticsPots = gameDoor.athletics.map({ $0.pot ?? Pot() })
        return AppList(athleticsPots,
                       placeHolder: """
                            No athletics have been added.

                            To add an athletic :
                            - select Athletics tab below ;
                            - select the + button on the top of the screen ;
                            - add new athletic's informations and confirm.
                            """,
                       commonPot: gameDoor.commonPot,
                       title: "Athletics pots")
            .environmentObject(gameDoor)
        .inNavigationHome(
            title: "pots",
            buttonImage: "gear",
            buttonDestination: PotsSettingsView(date: Date(), pointsForOneEuro: "")
                .environmentObject(gameDoor)
        )
    }
}
