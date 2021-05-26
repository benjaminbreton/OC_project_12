//
//  AthleticDetails.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
struct AthleticDetails: View {
    
    // MARK: - Properties
    
    /// Viewmodel.
    @EnvironmentObject var gameDoor: GameDoor
    /// Choosen athletic.
    let athletic: Athletic
    /// Athletic's image.
    private var image: UIImage? {
        guard let data = athletic.image else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            DetailsAthleticPicture(image: image)
            DetailsDateDisplayer(title: "athletics.details.creationDate".localized, date: athletic.creationDate)
            DetailsEvolutionGraph(title: "athletics.details.evolution".localized, datas: athletic.evolutionDatas, description: "graphic.description".localized, helpCanBeShown: gameDoor.showHelp)
            DetailsPerformancesDisplayer(performances: athletic.performances, source: athletic)
            
        }
        .inDetailsPage(
            genericTitle: athletic.name ?? "all.noName".localized,
            specificTitle: "athletics.details.title".localized,
            destinationToModify: AthleticSettings(athletic: athletic, name: athletic.name ?? "", image: UIImage(data: athletic.image ?? Data())),
            helpText: "athleticsDetails"
        )
    }
}
