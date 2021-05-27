//
//  AthleticsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
/**
 First page of athletics tab: display the athletics list.
 */
struct AthleticsHome: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        // display the list
        AppList(
            game.athletics,
            placeholder: "athletics.none".localized,
            helpText: "athleticsList"
        )
        .inNavigationHome(
            title: "athletics.title".localized,
            buttonImage: "person.crop.circle.badge.plus",
            buttonDestination: AthleticSettings(athletic: nil)
        )
    }
}
