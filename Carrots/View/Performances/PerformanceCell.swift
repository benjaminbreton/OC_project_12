//
//  PerformanceCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformanceCell: View {
    let performance: FakePerformance
    let multiplier: CGFloat = 4
    var rowHeight: CGFloat {
        ViewCommonSettings().commonHeight * multiplier * 2
    }
    var athleticsNames: String {
        guard let athletics = performance.athletics else { return "" }
        let athleticsNames = athletics.map({ "\($0.name ?? "No name")" }).joined(separator: ", ")
        return "Athletics: \(athleticsNames)"
    }
    var formattedValue: String {
        guard let sport = performance.sport else { return "" }
        let unity = sport.unityInt16.sportUnityType
        return "Realised: \(unity.singleString(for: performance.value))"
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(index: Int(performance.sport?.icon ?? 0), selectedIndex: nil, multiplier: multiplier)
                .frame(width: rowHeight / 2, height: rowHeight / 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            CommonWidthSpacer()
            VStack(alignment: .leading) {
                Text(performance.formattedDate)
                    .withLightSimpleFont()
                CommonHeightSpacer()
                Text(athleticsNames)
                    .withSimpleFont()
                CommonHeightSpacer()
                Text(formattedValue)
                    .withSimpleFont()
            }
            .frame(height: rowHeight)
        }
        //.withNavigationLink(destination: SportSettings(sport: sport, name: sport.name ?? "Name", icon: Int(sport.icon), unity: sport.unityInt16.sportUnityType, valueForOnePoint: valueArray))
    }
}
