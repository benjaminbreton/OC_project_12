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
            DetailsText(title: "Unity",
                        texts: [
                            "type: ": (text: sport.unityInt16.sportUnityType.description, order: 1),
                            "needs to get 1 point :": (text: "\(sport.valueForOnePoint)", order: 2)
            ])
        }
        .inDetailsPage(
            genericTitle: "sport details",
            specificTitle: sport.name ?? "No name",
            destinationToModify: SportSettings(sport: sport, name: sport.name ?? "No name", icon: sport.icon ?? "", unity: [sport.unityType], valueForOnePoint: sport.unityType.stringArray(for: sport.valueForOnePoint))
                .environmentObject(gameDoor)
        )
    }
}


