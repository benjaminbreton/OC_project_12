//
//  SportCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportCell: View {
    @EnvironmentObject var gameDoor: GameDoor
    let sport: Sport
    let lineCount: CGFloat = 2
    var rowHeight: CGFloat {
        ViewCommonSettings().textLineHeight * lineCount
    }
    var valueArray: [String] {
        switch sport.unityInt16.sportUnityType {
        case .time:
            let date = DateComponents(second: Int(sport.pointsConversion))
            guard let hours = date.hour, let minutes = date.minute, let seconds = date.second else {
                return ["0", "0", "0"]
            }
            return ["\(hours)", "\(minutes)", "\(seconds)"]
        default:
            return ["\(Int(sport.pointsConversion))", "0", "0"]
        }
    }
    var body: some View {
        HStack(alignment: .center) {
            SportIcon(icon: sport.icon ?? "", lineCount: lineCount)
                .frame(width: rowHeight, height: rowHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer()
              .frame(width: ViewCommonSettings().commonHeight)
            VStack(alignment: .leading) {
                Text(sport.name ?? "all.noName".localized)
                    .withBigSimpleFont()
                Text("\(sport.unityType.description)")
                    .withSimpleFont()
            }
            .frame(height: rowHeight)
        }
        .inRectangle(.leading)
        .withNavigationLink(destination:
                                SportDetails(sport: sport)
                                .environmentObject(gameDoor)
        )
        
    }
}
