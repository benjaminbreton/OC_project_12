//
//  PerformancesHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
/**
 First page of performances tab: display the performances list.
 */
struct PerformancesHome: View {
    
    // MARK: - Properties
    
    /// The ViewModel
    @EnvironmentObject private var game: GameViewModel
    /// The placeholder to display if the list can not be displayed.
    private var placeholder: String {
        if game.athletics.count == 0 {
            return "performances.none.noAthletics".localized
        } else if game.sports.count == 0 {
            return "performances.none.noSports".localized
        } else {
            return "performances.none.noPerformances".localized
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        // the performances list
        AppList(
            game.performances,
            placeholder: placeholder,
            helpText: "performancesList"
        )
        .inNavigationHome(
            title: "performances.title".localized,
            buttonImage: "gauge.badge.plus",
            buttonDestination:
                game.athletics.count > 0 && game.sports.count > 0 ?
                PerformanceSettings()
                :
                nil
        )
    }
}
