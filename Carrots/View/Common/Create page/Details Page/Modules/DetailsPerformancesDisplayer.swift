//
//  DetailsPerformancesDisplayer.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import SwiftUI
struct DetailsPerformancesDisplayer: View {
    let performances: [FakePerformance]
    var count: Int { performances.count }
    var body: some View {
        VStack {
            HStack {
                Text("Count : ")
                Text("\(count)")
                    .inRectangle(.leading)
            }
            .inModule("Performances")
            if performances.count > 0 {
                ListBase(items: performances.map({ PerformanceCell(performance: $0)}))
                    .frame(height: ViewCommonSettings().textLineHeight * 2 * (CGFloat(performances.count + 1)))
                    .inModule()
            }
        }
    }
}
