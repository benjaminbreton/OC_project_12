//
//  SportDetails.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/04/2021.
//

import SwiftUI
struct SportDetails: View {
    let sport: FakeSport
    var body: some View {
        VStack {
            CommonHeightSpacer()
            SportIcon(icon: sport.icon ?? "", lineCount: 5)
            CommonHeightSpacer(5)
            DetailsText(title: "Unity", texts: ["name: ": sport.unityInt16.sportUnityType.description, "value for one point :": ""])
        }
        .inDetailsPage(genericTitle: "sport details", specificTitle: sport.name ?? "No name", destinationToModify: SportSettings(name: sport.name ?? "No name", icon: sport.icon ?? ""))
        //.inDetailsPage(title: sport.name ?? "No name", destinationToModify: SportSettings(name: sport.name ?? "No name", icon: sport.icon ?? ""))
    }
}


