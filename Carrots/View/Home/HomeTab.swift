//
//  HomeTab.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI
struct HomeTab: View {
    @Binding var selection: Int
    @EnvironmentObject var game: GameViewModel
    var body: some View {
        TabView {
            PotsHome()
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("pots.title".localized)
                }
                .tag(0)
                .onAppear { game.refresh() }
            AthleticsHome()
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("athletics.title".localized)
                }
                .tag(1)
                .onAppear { game.refresh() }
            SportsHome()
                .tabItem {
                    Image(systemName: "bicycle.circle.fill")
                    Text("sports.title".localized)
                }
                .tag(2)
                .onAppear { game.refresh() }
            PerformancesHome()
                .tabItem {
                    Image(systemName: "arrow.up.right.circle.fill")
                    Text("performances.title".localized)
                }
                .tag(3)
                .onAppear { game.refresh() }
            GeneralSettings(date: game.predictionDate, moneyConversion: game.moneyConversion, showHelp: game.showHelp)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings.title".localized)
                }
                .tag(4)
                .onAppear{ game.refresh() }
        }
        .accentColor(.tab)
    }
}
