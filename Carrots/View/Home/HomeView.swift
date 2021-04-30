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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12")
        HomeView()
            .previewDevice("iPhone SE (1st generation)")
    }
}

