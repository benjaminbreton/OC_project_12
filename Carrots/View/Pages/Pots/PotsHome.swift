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
                       title: "Athletics pots",
                       helpText: """
                            Here is the page where you can see all the pots, if you already have added some athletics.

                            Each pot shows you its amount, and its expected value on a certain date if athletics keep doing performances on the same rythm.

                            By choosing the gear, you can set general pots settings, such as the needed number of points to get one euro and the date for the predicted amount.

                            By choosing a pot, you can add or withdraw some money to it.
                            """)
            .environmentObject(gameDoor)
        .inNavigationHome(
            title: "pots",
            buttonImage: "gear",
            buttonDestination: PotsGeneralSettings(
                date: gameDoor.predictedAmountDate,
                pointsForOneEuro: gameDoor.pointsForOneEuro, showHelp: gameDoor.showHelp)
                .environmentObject(gameDoor)
        )
    }
}
