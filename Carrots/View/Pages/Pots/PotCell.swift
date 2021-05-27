//
//  PotCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
/**
 The cell to display in a pots list.
 */
struct PotCell: View {
    
    // MARK: - Properties
    
    /// The ViewModel
    @EnvironmentObject private var game: GameViewModel
    /// The pot to display.
    private let pot: Pot?
    /// The pot's name to display.
    private var name: String { pot?.description ?? "all.noName".localized }
    
    // MARK: - Init
    
    init(pot: Pot?) {
        self.pot = pot
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack() {
            if let pot = pot {
                // pot's amount
                VStack {
                    Text(name)
                        .withBigSimpleFont()
                    Text("\(pot.formattedAmount)")
                        .withBigSimpleFont()
                        .layoutPriority(1)
                }
                Divider()
                // pot's amount's prediction
                HStack {
                    if pot.isFirstDay {
                        Text("\("pots.cell.noPrediction".localized)")
                            .withSimpleFont()
                    } else {
                        Image(systemName: pot.evolution.image.name)
                            .foregroundColor(Color(pot.evolution.image.color))
                            .withTitleFont()
                        Text("\("pots.cell.expected".localized) \(pot.formattedPredictionAmount)")
                            .withSimpleFont()
                            //.scaledToFill()
                            .layoutPriority(1)
                    }
                }
            }
        }
        .inRectangle(.leading)
        .inNavigationLink(
            PotAddings(pot: pot)
        )
    }
}
