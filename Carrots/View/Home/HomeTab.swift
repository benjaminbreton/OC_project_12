//
//  HomeTab.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI
struct HomeTab: View {
    @Binding var selection: Int
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        TabView {
            PotsHome()
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("pots")
                }
                .tag(0)
                .environmentObject(gameDoor)
                .onAppear { gameDoor.refresh() }
            AthleticsHome()
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("athletics")
                }
                .tag(1)
                .environmentObject(gameDoor)
                .onAppear { gameDoor.refresh() }
            SportsHome()
                .tabItem {
                    Image(systemName: "bicycle.circle.fill")
                    Text("sports")
                }
                .tag(2)
                .environmentObject(gameDoor)
                .onAppear { gameDoor.refresh() }
            PerformancesHome()
                .tabItem {
                    Image(systemName: "arrow.up.right.circle.fill")
                    Text("performances")
                }
                .tag(3)
                .environmentObject(gameDoor)
                .onAppear { gameDoor.refresh() }
            GeneralSettings(date: gameDoor.predictedAmountDate, pointsForOneEuro: gameDoor.pointsForOneEuro, showHelp: gameDoor.showHelp)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
                .tag(4)
                .environmentObject(gameDoor)
                .onAppear{ gameDoor.refresh() }
        }
        .accentColor(.tab)
    }
}
