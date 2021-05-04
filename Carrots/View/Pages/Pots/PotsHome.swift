//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct PotsHome: View {
    //let viewModel: ViewModel
    let viewModel: FakeViewModel
    
    var body: some View {
        let athleticsPots = viewModel.athletics.map({ $0.pot ?? FakePot(amount: 0, evolutionType: 0) })
        return AppList(athleticsPots,
                       placeHolder: """
                            No athletics have been added.

                            To add an athletic :
                            - select Athletics tab below ;
                            - select the + button on the top of the screen ;
                            - add new athletic's informations and confirm.
                            """,
                       commonPot: viewModel.commonPot,
                       title: "Athletics pots")
        .inNavigationHome(title: "pots", buttonImage: "gear", buttonDestination: PotsSettingsView(viewModel: viewModel, date: Date(), pointsForOneEuro: ""))
    }
}
