//
//  AthleticDetails.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
/**
 Details page displaying athletic's informations.
 */
struct AthleticDetails: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Choosen athletic.
    private let athletic: Athletic
    /// Athletic's image.
    private var image: UIImage? {
        guard let data = athletic.image else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Init
    
    init(athletic: Athletic) {
        self.athletic = athletic
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module displaying the athletic's image
            DetailsAthleticPicture(
                image: image
            )
            // module displaying the athletic's creation date
            DetailsDateDisplayer(
                title: "athletics.details.creationDate".localized,
                date: athletic.creationDate
            )
            // module displaying the athletic's evolution
            DetailsEvolutionGraph(
                title: "athletics.details.evolution".localized,
                datas: athletic.evolutionDatas,
                description: "graphic.description".localized
            )
            // module displaying the athletic's performances list
            DetailsPerformancesDisplayer(
                performances: athletic.performances,
                source: athletic
            )
        }
        .inDetailsPage(
            navigationTitle: athletic.description,
            specificTitle: "athletics.details.title".localized,
            destinationToModify: AthleticSettings(athletic),
            helpText: "athleticsDetails"
        )
    }
}
