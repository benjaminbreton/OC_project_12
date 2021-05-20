//
//  SportDetails.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/04/2021.
//

import SwiftUI
struct SportDetails: View {
    @EnvironmentObject var gameDoor: GameDoor
    let sport: Sport
    var body: some View {
        VStack {
            CommonHeightSpacer()
            SportIcon(icon: sport.icon ?? "", lineCount: 5)
            CommonHeightSpacer(5)
            DetailsText(title: "sports.details.unityTitle".localized,
                        texts: [
                            "sports.details.unityTypeTitle".localized: (text: sport.unityInt16.sportUnityType.description, order: 1),
                            sport.unityType == .oneShot ? "sports.details.oneShot".localized : "sports.details.needs".localized: (text: "\(sport.unityType.singleString(for: sport.valueForOnePoint))", order: 2)
                        ])
            DetailsPerformancesDisplayer(performances: sport.performances, source: nil)
        }
        .inDetailsPage(
            genericTitle: sport.name ?? "all.noName".localized,
            specificTitle: "sports.details.title".localized,
            destinationToModify: SportSettings(sport: sport, name: sport.name ?? "all.noName".localized, icon: sport.icon ?? "A", unity: [sport.unityType], valueForOnePoint: sport.unityType.stringArray(for: sport.valueForOnePoint))
                .environmentObject(gameDoor),
            helpText: "sportsDetails"
        )
    }
}
