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
    
    var body: some View {
        setTabAppearance()
        setNavigationAppearance()
        return NavigationView {
            HomeTab(viewModel: viewModel, selection: $selection)
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
}
struct TabNavigationItem: View {
    @Binding var selection: Int
    let viewModel: FakeViewModel
    var body: some View {
        switch selection {
        case 0:
            NavigationBarButton(
                image: selection.navigationButtonImage,
                destination: AppSettings(date: Date() + 30 * 24 * 3600, points: "1000"))
            
        case 1:
            NavigationBarButton(
                image: selection.navigationButtonImage,
                destination: AthleticSettings(athletic: nil, name: "", image: nil))
        case 3:
            NavigationBarButton(
                image: selection.navigationButtonImage,
                destination: PerformanceSettings(sportsArray: viewModel.sports, athleticsArray: viewModel.athletics))
        case 2:
            NavigationBarButton(
                image: selection.navigationButtonImage,
                destination: SportSettings( name: "", icon: ""))
        default:
            NavigationBarButton(image: "", destination: Text(""))
        }
    }
}

struct HomeTab: View {
    let viewModel: FakeViewModel
    @Binding var selection: Int
    
    var body: some View {
        TabView {
            PotsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("pots")
                }
                .tag(0)
            AthleticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "figure.walk.circle.fill")
                    Text("athletics")
                }
                .tag(1)
            
            SportsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "bicycle.circle.fill")
                    Text("sports")
                }
                .tag(2)
            PerformancesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "arrow.up.right.circle.fill")
                    Text("performances")
                }
                .tag(3)
        }
        .navigationBarTitle(Text(selection.tabTitle))
        .navigationBarItems(trailing: TabNavigationItem(selection: _selection, viewModel: viewModel))
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

