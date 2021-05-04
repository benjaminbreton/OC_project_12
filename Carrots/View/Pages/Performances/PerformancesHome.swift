//
//  PerformancesHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformancesHome: View {
    let viewModel: FakeViewModel
    var instructions: String {
        if viewModel.athletics.count > 0 {
            return " you have to add at least one athletic. Select Athletics on the tab bar below and follow instructions to add athletics"
        } else if viewModel.sports.count > 0 {
            return " you have to add at least one sport. Select Sports on the tab bar below and follow instructions to add sports."
        } else {
            return """
 :
- select the plus button on the top of this screen ;
- enter performances informations ;
- confirm.
"""
        }
    }
    var body: some View {
        AppList(viewModel.performances, placeHolder: """
            No performances have been added.

            To add a performance \(instructions)
            """)
//        VStack {
//            Divider()
//            if viewModel.performances.count > 0 {
//                    ListBase(items: viewModel.performances.map({
//                        PerformanceCell(performance: $0)
//                    }))
//            } else {
//                Text("""
//            No performances have been added.
//
//            To add a performance \(instructions)
//            """)
//                    .withSimpleFont()
//                    .inRectangle(.topLeading)
//            }
//            Divider()
//        }
        .inNavigationHome(title: "performances", buttonImage: "gauge.badge.plus", buttonDestination: PerformanceSettings(sportsArray: viewModel.sports, athleticsArray: viewModel.athletics))
    }
}
