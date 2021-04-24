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
            DetailsTextDisplayer(title: "Unity", texts: ["name: ": sport.unityInt16.sportUnityType.description, "value for one point :": ""])
        }
        .inDetailsPage(title: sport.name ?? "No name", destinationToModify: SportSettings(name: sport.name ?? "No name", icon: sport.icon ?? ""))
    }
}
struct DetailsTextDisplayer: View {
    let title: String
    let texts: [String: String]
    var keys: [String] {
        texts.keys.map({ "\($0.description)" })
    }
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            ForEach(keys.indices) { index in
                HStack {
                    Text(keys[index])
                    Text(texts[keys[index]] ?? "")
                }
                .withSimpleFont()
                .inRectangle(.leading)
            }
        }
    }
}

