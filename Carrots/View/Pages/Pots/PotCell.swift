//
//  PotCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotCell: View {
    @EnvironmentObject var game: GameViewModel
    let pot: Pot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? "all.noName".localized
        } else {
            return "pots.commonPot".localized
        }
    }
    var body: some View {
        VStack() {
            VStack {
                Text(name)
                    .withBigSimpleFont()
                Text("\(pot?.formattedAmount ?? "")")
                    .withBigSimpleFont()
                    .layoutPriority(1)
            }
            
            Divider()
            HStack {
                if pot?.isFirstDay ?? false {
                    Text("\("pots.cell.noPrediction".localized)")
                        .withSimpleFont()
                        .scaledToFill()
                        .layoutPriority(1)
                } else {
                    Image(systemName: pot?.evolution.image.name ?? "")
                        .foregroundColor(Color(pot?.evolution.image.color ?? ""))
                        .withTitleFont()
                    Text("\("pots.cell.expected".localized) \(pot?.formattedPredictionAmount ?? "")")
                        .withSimpleFont()
                        .scaledToFill()
                        .layoutPriority(1)
                }
            }
            
        }
        .padding()
        .inCellRectangle()
        .withNavigationLink(
            destination: PotAddings(pot: pot)
        )
    }
}
