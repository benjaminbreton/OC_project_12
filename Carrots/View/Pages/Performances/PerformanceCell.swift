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
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// The performance to display.
    private let performance: Performance
    /// Boolean indicating whether the maximum number of athletics to display in a cell has been reached or not.
    private var didReachedMaxAthletics: Bool { performance.athletics.count > 5 }
    /// Athletics list to display in the cell.
    private var athleticsToShow: [Athletic] {
        if performance.athletics.count > 5 {
            var athletics = performance.athletics
            athletics.removeLast(performance.athletics.count - 5)
            return athletics
        } else {
            return performance.athletics
        }
    }
    
    // MARK: - Init
    
    init(_ performance: Performance) {
        self.performance = performance
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center) {
            // performance's sport
            SportIcon(icon: performance.initialSportIcon ?? "", lineCount: 3)
            HorizontalSpacer()
            VStack(alignment: .leading) {
                // date
                Text(performance.formattedDate)
                    .withLightSimpleFont()
                VerticalSpacer(0.5)
                // performance
                Text(performance.formattedValue)
                    .withSimpleFont()
                VerticalSpacer(0.5)
                // athletics
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
        .inRectangle(.leading)
    }
}
