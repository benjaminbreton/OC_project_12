//
//  PotCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotCell: View {
    @EnvironmentObject var gameDoor: GameDoor
    let pot: Pot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? ""
        } else {
            return "Common pot"
        }
    }
    var body: some View {
        VStack() {
            HStack {
                Text(name)
                    .withBigSimpleFont()
                Text("\(pot?.formattedAmount ?? "")")
                    .withBigSimpleFont()
                    .layoutPriority(1)
            }
            
            Divider()
            HStack {
                Image(systemName: pot?.formattedEvolutionType.image.name ?? "arrow.forward.square")
                    .foregroundColor(pot?.formattedEvolutionType.image.colorInt16.potEvolutionColor)
                    .withTitleFont()
                Text("expected: \(pot?.formattedAmount ?? "")")
                    .withSimpleFont()
                    .scaledToFill()
                    .layoutPriority(1)
            }
            
        }
        .padding()
        .inCellRectangle()
        .withNavigationLink(
            destination: PotAddings(pot: pot)
                .environmentObject(gameDoor)
        )
    }
}
