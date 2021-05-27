//
//  DetailsPerformancesDisplayer.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import SwiftUI

/**
 Display a performances list in a module.
 */
struct DetailsPerformancesDisplayer: View {
    
    // MARK: - Properties
    
    /// Performances to display.
    private let performances: [Performance]
    /// Performances count.
    private var count: Int { performances.count }
    /// If this module is used in an athletic's details page, here is this athletic.
    private let source: Athletic?
    
    // MARK: - Init
    
    init(performances: [Performance], source: Athletic?) {
        self.performances = performances
        self.source = source
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Display performances count
            HStack {
                Text("all.count".localized)
                Text("\(count)")
            }
            .inModule("performances.title.maj".localized)
            // Display performances list
            if performances.count > 0 {
                AppList(performances, placeholder: "performances.none".localized, withDivider: false, source: source)
                    .frame(height: ViewCommonSettings().textLineHeight * 4 * (CGFloat(performances.count + 1)))

            }
        }
    }
}
