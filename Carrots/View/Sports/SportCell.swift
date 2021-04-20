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
            return ["\(Int(sport.valueForOnePoint))", "0", "0"]
        }
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(icon: sport.icon ?? "", multiplier: multiplier)
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
        .withNavigationLink(destination: SportSettings(name: sport.name ?? "", icon: sport.icon ?? ""))
    }
}
