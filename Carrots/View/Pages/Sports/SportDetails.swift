//
//  SportDetails.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/04/2021.
//

import SwiftUI
/**
 Details page displaying sport's informations.
 */
struct SportDetails: View {
    
    // MARK: - Properties
    
    /// The choosen sport.
    private let sport: Sport
    /// The choosen sport's unity type's value's localized title.
    private var sportUnityValueTitle: String {
        sport.unityType == .oneShot ? "sports.details.oneShot".localized : "sports.details.needs".localized
    }
    
    // MARK: - Init
    
    init(sport: Sport) {
        self.sport = sport
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module displaying sport's icon
            DetailsSportIcon(
                icon: sport.icon ?? "A"
            )
            // module displaying the sport unity type and its value
            DetailsText(
                title: "sports.details.unityTitle".localized,
                texts: [
                    "sports.details.unityTypeTitle".localized: (
                        text: sport.unityInt16.sportUnityType.description,
                        order: 1
                    ),
                    sportUnityValueTitle: (
                        text: "\(sport.pointsConversionSingleString)",
                        order: 2
                    )
                ]
            )
            // module displaying sport's performances list
            DetailsPerformancesDisplayer(
                performances: sport.performances,
                source: nil
            )
        }
        .inDetailsPage(
            navigationTitle: sport.description,
            specificTitle: "sports.details.title".localized,
            destinationToModify: SportSettings(sport),
            helpText: "sportsDetails"
        )
    }
}
