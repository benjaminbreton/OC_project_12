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
        let athleticsPots = viewModel.athletics.map({$0.pot})
        return VStack {
            Divider()
            ScrollView(.vertical) {
                VStack {
                    CommonHeightSpacer()
                    NavigationPotCell(pot: viewModel.commonPot)
                        .frame(width: .none, height: ViewCommonSettings().commonPotLineHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Divider().padding()
                    Text("Athletics pots")
                        .withBigTitleFont()
                    if athleticsPots.count > 0 {
                        ScrollView(.vertical) {
                            ForEach(athleticsPots.indices) { index in
                                NavigationPotCell(pot: athleticsPots[index] )
                            }
                        }
                    } else {
                        Text("""
                            No athletics have been added.

                            To add an athletic :
                            - select Athletics tab below ;
                            - select the + button on the top of the screen ;
                            - add new athletic's informations and confirm.
                            """)
                            .withSimpleFont()
                            .inRectangle(.topLeading)
                    }
                }
            }
            Divider()
        }
        .inNavigationHome(title: "pots", buttonImage: "gear", buttonDestination: PotsSettingsView(viewModel: viewModel, date: Date(), pointsForOneEuro: ""))
    }
}
