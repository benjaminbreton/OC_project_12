//
//  PerformanceCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI
/**
 The cell to display in a performances list.
 */
struct PerformanceCell: View {
    @EnvironmentObject var game: GameViewModel
    let performance: Performance
    private var lineCount: CGFloat {
        3
    }
    private var rowHeight: CGFloat {
        ViewCommonSettings().textLineHeight * lineCount
    }
    private var didReachedMaxAthletics: Bool { performance.athletics.count > 5 }
    private var athleticsToShow: [Athletic] {
        if performance.athletics.count > 5 {
            var athletics = performance.athletics
            athletics.removeLast(performance.athletics.count - 5)
            return athletics
        } else {
            return performance.athletics
        }
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(icon: performance.initialSportIcon ?? "", lineCount: lineCount)
            HorizontalSpacer()
            VStack(alignment: .leading) {
                Text(performance.formattedDate)
                    .withLightSimpleFont()
                VerticalSpacer(0.5)
                Text(performance.formattedValue)
                    .withSimpleFont()
                VerticalSpacer(0.5)
                HStack(spacing: 0.7) {
                    ForEach(athleticsToShow) { athletic in
                        AthleticImage(image: UIImage(data: athletic.image ?? Data()), radius: ViewCommonSettings().textLineHeight / 3)
                    }
                    if didReachedMaxAthletics {
                        Image(systemName: "plus.circle.fill")
                            .withLightSimpleFont()
                    }
                }
            }
        }
        .frame(height: rowHeight)
        .inRectangle(.leading)
    }
}
