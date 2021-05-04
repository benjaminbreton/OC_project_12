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
            DetailsDateDisplayer(title: "Creation date", date: athletic.creationDate)
            DetailsEvolutionGraph(title: "Evolution", datas: athletic.evolutionDatas, description: "Points earned per second the last 30 days.")
            DetailsPerformancesDisplayer(performances: athletic.performances)
            
        }
        .inDetailsPage(
            genericTitle: "profile",
            specificTitle: athletic.name ?? "No name",
            destinationToModify: AthleticSettings(athletic: athletic, name: athletic.name ?? "", image: UIImage(data: athletic.image ?? Data()))
                .environmentObject(gameDoor)
        
        )
    }
}
