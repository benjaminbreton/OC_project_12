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
    @State private var selection = 3
    
    let types: [PageType] = [.pots, .athletics, .sports, .performances]
    
    var body: some View {
        setTabAppearance()
        setNavigationAppearance()
        return NavigationView {
            TabView(selection: $selection) {
                ForEach(types.indices) { index in
                    TabPageView(type: types[index], viewModel: viewModel, tag: index)
                }
            }
            .navigationBarTitle(Text(types[selection].name))
            .navigationBarItems(trailing: TabNavigationItem(type: types[selection], viewModel: viewModel))
            .accentColor(.tab)
        }
        .accentColor(.title)
        
    }
    private func setTabAppearance() {
        UITabBar.appearance().backgroundImage = UIImage()
    }
    private func setNavigationAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [.font : ViewCommonSettings().regularNavigationTitleFont]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : ViewCommonSettings().largeNavigationTitleFont]
    }
    enum PageType {
        case pots, athletics, performances, sports
        var name: String {
            switch self {
            case .pots:
                return "Pots"
            case .athletics:
                return "Athletics"
            case .performances:
                return "Performances"
            case .sports:
                return "Sports"
            }
        }
        var image: String {
            switch self {
            case .pots:
                return "creditcard.circle.fill"
            case .athletics:
                return "figure.walk.circle.fill"
            case .performances:
                return "arrow.up.right.circle.fill"
            case .sports:
                return "bicycle.circle.fill"
            }
        }
    
        var navigationButtonImage: String {
            switch self {
            case .pots:
                return "gear"
            case .athletics:
                return "person.crop.circle.badge.plus"
            case .performances:
                return "gauge.badge.plus"
            case .sports:
                return "plus.circle"
            }
        }
    }
}
struct TabPageView: View {
    let type: HomeView.PageType
    let viewModel: FakeViewModel
    let tag: Int
    var body: some View {
        switch type {
        case .pots:
            PotsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: type.image)
                    Text(type.name)
                }
                .tag(tag)
        case .athletics:
            AthleticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: type.image)
                    Text(type.name)
                }
                .tag(tag)
        case .performances:
            PerformancesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: type.image)
                    Text(type.name)
                }
                .tag(tag)
        case .sports:
            SportsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: type.image)
                    Text(type.name)
                }
                .tag(tag)
        }
    }
}
struct TabNavigationItem: View {
    let type: HomeView.PageType
    let viewModel: FakeViewModel
    var body: some View {
        switch type {
        case .pots:
            NavigationBarButton(
                image: type.navigationButtonImage,
                destination: AppSettings(date: Date() + 30 * 24 * 3600, points: "1000"))
            
        case .athletics:
            NavigationBarButton(
                image: type.navigationButtonImage,
                destination: AthleticSettings(athletic: nil, name: "", image: nil))
        case .performances:
            NavigationBarButton(
                image: type.navigationButtonImage,
                destination: PerformanceSettings(sportsArray: viewModel.sports, athleticsArray: viewModel.athletics))
            
        case .sports:
            NavigationBarButton(
                image: type.navigationButtonImage,
                destination: SportSettings( name: "", icon: ""))
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

