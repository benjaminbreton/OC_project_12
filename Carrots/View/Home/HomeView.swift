//
//  HomeView.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/04/2021.
//

import SwiftUI

struct HomeView: View {
    //@ObservedObject var viewModel: ViewModel = ViewModel()
    var viewModel = FakeViewModel.create()
    @State private var selection = 0
    
    var body: some View {
        setTabAppearance()
        setNavigationAppearance()
        setUITableViewAppearance()
        return HomeTab(viewModel: viewModel, selection: $selection)
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


struct HomeTab: View {
    let viewModel: FakeViewModel
    @Binding var selection: Int
    
    var body: some View {
        TabView {
            PotsHome(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("pots")
                }
                .tag(0)
            AthleticsHome(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("athletics")
                }
                .tag(1)
            
            SportsHome(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "bicycle.circle.fill")
                    Text("sports")
                }
                .tag(2)
            PerformancesHome(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "arrow.up.right.circle.fill")
                    Text("performances")
                }
                .tag(3)
        }
        .accentColor(.tab)
    }
}
extension Int {
    var tabTitle: String {
        switch self {
        case 0:
            return "pots"
        case 1:
            return "athletics"
        case 2:
            return "sports"
        case 3:
            return "performances"
        default:
            return "error"
        }
    }
    var navigationButtonImage: String {
        switch self {
        case 0:
            return "gear"
        case 1:
            return "person.crop.circle.badge.plus"
        case 3:
            return "gauge.badge.plus"
        case 2:
            return "plus.circle"
        default:
            return "xmark"
        }
    }
}







struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12")
        HomeView()
            .previewDevice("iPhone SE (1st generation)")
    }
}

