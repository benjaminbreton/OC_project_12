//
//  DetailsPerformancesDisplayer.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import SwiftUI
struct DetailsPerformancesDisplayer: View {
    let performances: [Performance]
    var count: Int { performances.count }
    let source: Athletic?
    var body: some View {
        VStack {
            HStack {
                Text("all.count".localized)
                Text("\(count)")
            }
            .inModule("performances.title.maj".localized)
            if performances.count > 0 {
                AppList(performances, placeHolder: "performances.none".localized, withDivider: false, source: source)
                    .frame(height: ViewCommonSettings().textLineHeight * 4 * (CGFloat(performances.count + 1)))

            }
        }
    }
}
