//
//  SportsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 First page of sports tab: display the sports list.
 */
struct SportsHome: View {
    
    // MARK: - Property
    
    /// The ViewModel.
    @EnvironmentObject var game: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        // sports list
        AppList(
            game.sports,
            placeholder: "sports.noSports".localized,
            helpText: "sportsList"
        )
        .inNavigationHome(
            title: "sports.title".localized,
            buttonImage: "plus.circle",
            buttonDestination: SportSettings()
        )
    }
}




