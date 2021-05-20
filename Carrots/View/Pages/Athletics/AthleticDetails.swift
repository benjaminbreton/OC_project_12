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
            DetailsEvolutionGraph(title: "Evolution", datas: athletic.evolutionDatas, description: "Points earned per second the last 30 days.", helpCanBeShown: gameDoor.showHelp)
            DetailsPerformancesDisplayer(performances: athletic.performances, source: athletic)
            
        }
        .inDetailsPage(
            genericTitle: athletic.name ?? "No name",
            specificTitle: "Profile",
            destinationToModify: AthleticSettings(athletic: athletic, name: athletic.name ?? "", image: UIImage(data: athletic.image ?? Data()))
                .environmentObject(gameDoor),
            helpText: """
                This page is an athletic's profile, \(athletic.name ?? "No name")'s here.

                You will see his informations, his evolution, and his performances.

                By stay pressed on a performance, you can delete it. This action will delete the athletic's participation on this performance, but not the performance itself (except if the athletic was alone). To delete the performance, you have to do the same action on the dedicated performances page.
                """
        )
    }
}
