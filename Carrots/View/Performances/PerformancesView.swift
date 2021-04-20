//
//  PerformancesView.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformancesView: View {
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
        FirstPageView(array: viewModel.performances,
                      noArrayText: """
            No performances have been added.

            To add a performance \(instructions)
            """)
    }
}

struct FirstPageView<T>: View {
    let array: [T]
    let noArrayText: String
    var body: some View {
        VStack {
            Divider()
            if array.count > 0 {
                if let sports = array as? [FakeSport] {
                    ListBase(items: sports.map({
                        SportCell(sport: $0)
                    }))
                }
                if let performances = array as? [FakePerformance] {
                    ListBase(items: performances.map({
                        PerformanceCell(performance: $0)
                    }))
                }
            } else {
                Text(noArrayText)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
            }
            Divider()
        }
        .withAppBackground()
        .closeKeyboardOnTap()
    }
}
