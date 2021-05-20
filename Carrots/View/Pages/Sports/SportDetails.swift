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
                            sport.unityType == .oneShot ? "one shot: " : "needs to get 1 point: ": (text: "\(sport.unityType.singleString(for: sport.valueForOnePoint))", order: 2)
            ])
            DetailsPerformancesDisplayer(performances: sport.performances, source: nil)
        }
        .inDetailsPage(
            genericTitle: sport.name ?? "No name",
            specificTitle: "Details",
            destinationToModify: SportSettings(sport: sport, name: sport.name ?? "No name", icon: sport.icon ?? "", unity: [sport.unityType], valueForOnePoint: sport.unityType.stringArray(for: sport.valueForOnePoint))
                .environmentObject(gameDoor),
            helpText: """
                You can see on this page all informations about a sport, \(sport.name ?? "No name")'s informations here : name, icon, unity to measure performances on this sport, the needed value to get one point (directly the number of points you can earn in cas of one shot unity), and the performances.

                By stay pressed on a performance, you can delete it.
                """
        )
    }
}


