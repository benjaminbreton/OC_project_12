//
//  PerformanceCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
struct PerformanceCell: View {
    @EnvironmentObject var gameDoor: GameDoor
    let performance: Performance
    private var lineCount: CGFloat {
        3
    }
    private var rowHeight: CGFloat {
        ViewCommonSettings().textLineHeight * lineCount
    }
    private var athleticsNames: String {
        let athleticsNames = performance.athletics.map({ "\($0.name ?? "No name")" }).joined(separator: ", ")
        return "Athletics: \(athleticsNames)"
    }
    private var formattedValue: String {
        guard let sport = performance.sport else { return "" }
        let unity = sport.unityType
        return unity != .oneShot ? "Realised: \(unity.singleString(for: performance.value))" : "*one shot*"
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
                Text(formattedValue)
                    .withSimpleFont()
                CommonHeightSpacer()
                HStack(spacing: 0.7) {
                    ForEach(performance.athletics) { athletic in
                        AthleticImage(image: UIImage(data: athletic.image ?? Data()), radius: ViewCommonSettings().textLineHeight / 3)
                    }
                }
            }
            .frame(height: rowHeight)
        }
        .inRectangle(.leading)
    }
}
