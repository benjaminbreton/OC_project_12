//
//  PerformancesHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformancesHome: View {
    @EnvironmentObject var gameDoor: GameDoor
    var placeholder: String {
        if gameDoor.athletics.count == 0 {
            return "performances.none.noAthletics".localized
        } else if gameDoor.sports.count == 0 {
            return "performances.none.noSports".localized
        } else {
            return "performances.none.noPerformances".localized
        }
    }
    var body: some View {
        AppList(gameDoor.performances, placeHolder: placeholder, helpText: "performancesList")
            .inNavigationHome(
                title: "performances.title".localized,
                buttonImage: "gauge.badge.plus",
                buttonDestination:
                    gameDoor.athletics.count > 0 && gameDoor.sports.count > 0 ?
                    PerformanceSettings().environmentObject(gameDoor)
                    :
                    nil
            )
    }
}
