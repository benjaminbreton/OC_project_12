//
//  HomeTab.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI

// MARK: - HomeTab

/**
 HomeTab is the view containing the tab view used to select pages between Pots, Athletics, Sports, Performances, and Settings.
 */
struct HomeTab: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject var game: GameViewModel
    /// The selected tab's index.
    @Binding var selection: Int
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            PotsHome()
                .inTabItem(0)
            AthleticsHome()
                .inTabItem(1)
            SportsHome()
                .inTabItem(2)
            PerformancesHome()
                .inTabItem(3)
            GeneralSettings()
                .inTabItem(4)
        }
        .accentColor(.tab)
    }
}

// MARK: - Tab items ViewModifier

fileprivate struct InTabItem: ViewModifier {
    
    // MARK: - Properties
    
    /// The ViewModel
    @EnvironmentObject var game: GameViewModel
    /// Tab's index.
    let index: Int
    /// Image to display.
    private var image: String { index.tabItemImage }
    /// Text to display.
    private var text: String { index.tabItemText }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                Image(systemName: image)
                Text(text)
            }
            .tag(index)
            .onAppear { game.refresh() }
    }
}

// MARK: - View's extension

fileprivate extension View {
    func inTabItem(_ index: Int) -> some View {
        modifier(InTabItem(index: index))
    }
}

// MARK: - Int's extension

fileprivate extension Int {
    
    /// Tab items image's name regarding their index.
    var tabItemImage: String {
        switch self {
        case 0:
            return "creditcard.circle.fill"
        case 1:
            return "figure.walk.circle.fill"
        case 2:
            return "bicycle.circle.fill"
        case 3:
            return "arrow.up.right.circle.fill"
        default:
            return "gear"
        }
    }
    /// Tab items text regarding their index.
    var tabItemText: String {
        switch self {
        case 0:
            return "pots.title".localized
        case 1:
            return "athletics.title".localized
        case 2:
            return "sports.title".localized
        case 3:
            return "performances.title".localized
        default:
            return "settings.title".localized
        }
    }
}

