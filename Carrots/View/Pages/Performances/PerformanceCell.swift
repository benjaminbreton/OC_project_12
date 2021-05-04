//
//  PerformanceCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformanceCell: View {
    let performance: FakePerformance
    private var lineCount: CGFloat {
        2
    }
    private var rowHeight: CGFloat {
        ViewCommonSettings().textLineHeight * lineCount
    }
    private var athleticsNames: String {
        guard let athletics = performance.athletics else { return "" }
        let athleticsNames = athletics.map({ "\($0.name ?? "No name")" }).joined(separator: ", ")
        return "Athletics: \(athleticsNames)"
    }
    private var formattedValue: String {
        guard let sport = performance.sport else { return "" }
        let unity = sport.unityInt16.sportUnityType
        return "Realised: \(unity.singleString(for: performance.value))"
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(icon: performance.sport?.icon ?? "", lineCount: lineCount)
                .frame(width: rowHeight, height: rowHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            CommonWidthSpacer()
            VStack(alignment: .leading) {
                Text(performance.formattedDate)
                    .withLightSimpleFont()
                CommonHeightSpacer()
//                Text(athleticsNames)
//                    .withSimpleFont()
//                CommonHeightSpacer()
                Text(formattedValue)
                    .withSimpleFont()
            }
            .frame(height: rowHeight)
        }
        .inRectangle(.leading)
    }
}
