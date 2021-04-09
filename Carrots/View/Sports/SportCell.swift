//
//  SportCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportCell: View {
    let sport: FakeSport
    let multiplier: CGFloat = 4
    var rowHeight: CGFloat {
        ViewCommonSettings().commonHeight * multiplier
    }
    var body: some View {
        print(ViewCommonSettings().sportsIconsCharacters[Int(sport.icon)])
        return HStack(alignment: .center) {
            SportIcon(icon: ViewCommonSettings().sportsIconsCharacters[Int(sport.icon)], multiplier: multiplier)
                .frame(width: rowHeight, height: rowHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer()
                .frame(width: ViewCommonSettings().commonHeight)
            VStack(alignment: .leading) {
                Text(sport.name ?? "No name")
                    .withBigSimpleFont()
                Text("unity: \(sport.unityInt16.sportUnityType.description)")
                    .withSimpleFont()
            }
            .frame(height: rowHeight)
        }
        .withNavigationLink(destination: SportSettings(sport: sport, name: sport.name ?? "Name", unity: sport.unityInt16.sportUnityType))
    }
}
