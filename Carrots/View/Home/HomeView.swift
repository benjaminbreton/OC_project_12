//
//  HomeView.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/04/2021.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 0
    @ObservedObject var gameDoor: GameDoor
    
    init(_ coreDataStack: CoreDataStack) {
        gameDoor = GameDoor(coreDataStack)
    }
    var body: some View {
        setTabAppearance()
        setNavigationAppearance()
        setUITableViewAppearance()
        return HomeTab(selection: $selection)
            .environmentObject(gameDoor)
    }
    private func setTabAppearance() {
        UITabBar.appearance().backgroundImage = UIImage()
    }
    private func setNavigationAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [.font : ViewCommonSettings().regularNavigationTitleFont]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : ViewCommonSettings().largeNavigationTitleFont]
    }
    private func setUITableViewAppearance() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(CoreDataStack())
            .previewDevice("iPhone 12")
        HomeView(CoreDataStack())
            .previewDevice("iPhone SE (1st generation)")
    }
}

