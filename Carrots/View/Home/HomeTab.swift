//
//  HomeTab.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI
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
