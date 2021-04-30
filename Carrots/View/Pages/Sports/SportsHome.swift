//
//  SportsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportsHome: View {
    let viewModel: FakeViewModel
    var body: some View {
        

        VStack {
            Divider()
            if viewModel.sports.count > 0 {
                ListBase(items: viewModel.sports.map({
                    SportCell(sport: $0)
                }))
            } else {
                Text("""
                    No sports have been added.

                    To add a sport, press the + button on the top of the screen, and set sport's informations.
                    """)
                    .withSimpleFont()
                    .inRectangle(.leading)
            }
            Divider()
        }
        .inNavigationHome(title: "sports", buttonImage: "plus.circle", buttonDestination: SportSettings(name: "", icon: ""))
    }
}




