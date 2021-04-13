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
    var valueArray: [String] {
        switch sport.unityInt16.sportUnityType {
        case .time:
            let date = DateComponents(second: Int(sport.valueForOnePoint))
            guard let hours = date.hour, let minutes = date.minute, let seconds = date.second else {
                return ["0", "0", "0"]
            }
            return ["\(hours)", "\(minutes)", "\(seconds)"]
        default:
            return ["\(Int(sport.valueForOnePoint))"]
        }
    }
    var body: some View {
        print(ViewCommonSettings().sportsIconsCharacters[Int(sport.icon)])
        return HStack(alignment: .center) {
            SportIcon(index: Int(sport.icon), selectedIndex: nil, multiplier: multiplier)
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
        .withNavigationLink(destination: SportSettings(sport: sport, name: sport.name ?? "Name", icon: Int(sport.icon), unity: sport.unityInt16.sportUnityType, valueForOnePoint: valueArray))
    }
}
