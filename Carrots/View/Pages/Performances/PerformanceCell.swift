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
    private var formattedValue: String {
        let unity = performance.initialUnity.sportUnityType
        return unity != .oneShot ? "\(unity.singleString(for: performance.value))" : "performances.oneShot".localized
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(icon: performance.initialSportIcon ?? "", lineCount: lineCount)
                .frame(width: rowHeight, height: rowHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            CommonWidthSpacer()
            VStack(alignment: .leading) {
                Text(performance.formattedDate)
                    .withLightSimpleFont()
                CommonHeightSpacer(0.5)
                Text(formattedValue)
                    .withSimpleFont()
                CommonHeightSpacer(0.5)
                HStack(spacing: 0.7) {
                    ForEach(performance.athletics) { athletic in
                        AthleticImage(image: UIImage(data: athletic.image ?? Data()), radius: ViewCommonSettings().textLineHeight / 3)
                    }
                }
            }
        }
        .frame(height: rowHeight)
        .inRectangle(.leading)
    }
}
