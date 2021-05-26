//
//  HomeView.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/04/2021.
//

import SwiftUI

/**
 HomeView is the first view to be loaded by the app. It loads the game, sets appearances, create the ViewModel and add it as an EnvironmentObject when calling HomeTab.
 */
struct HomeView: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @ObservedObject private var game: GameViewModel
    /// The selected tab's index.
    @State private var selection = 0
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        game = GameViewModel(coreDataStack)
    }
    
    // MARK: - Body
    
    var body: some View {
        setTabAppearance()
        setNavigationAppearance()
        return HomeTab(selection: $selection)
            .environmentObject(game)
    }
    private func setTabAppearance() {
        UITabBar.appearance().backgroundImage = UIImage()
    }
    private func setNavigationAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : ViewCommonSettings().largeNavigationTitleFont]
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(CoreDataStack())
            .previewDevice("iPhone 12")
        HomeView(CoreDataStack())
            .previewDevice("iPhone SE (1st generation)")
    }
}

