//
//  PerformancesHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformancesHome: View {
    @EnvironmentObject var gameDoor: GameDoor
    var instructions: String {
        if gameDoor.athletics.count > 0 {
            return " you have to add at least one athletic. Select Athletics on the tab bar below and follow instructions to add athletics"
        } else if gameDoor.sports.count > 0 {
            return " you have to add at least one sport. Select Sports on the tab bar below and follow instructions to add sports."
        } else {
            return """
 :
- select the plus button on the top of this screen ;
- enter performances informations ;
- confirm.
"""
        }
    }
    var body: some View {
        AppList(gameDoor.performances, placeHolder: """
            No performances have been added.

            To add a performance \(instructions)
            """, helpText: """
                        This page shows you the list of performances.

                        By choosing the plus button, you can add a performance.

                        By stay pressed on a performance, you can delete it (the deletion on this page will cancel all points earned because of it).
                        """)
        .inNavigationHome(
            title: "performances",
            buttonImage: "gauge.badge.plus",
            buttonDestination:
                gameDoor.athletics.count > 0 && gameDoor.sports.count > 0 ?
                PerformanceSettings().environmentObject(gameDoor)
                :
                nil
        )
    }
}
