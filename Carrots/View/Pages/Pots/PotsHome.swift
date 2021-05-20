//
//  PotsView.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct PotsHome: View {
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        let athleticsPots = gameDoor.athletics.map({ $0.pot ?? Pot() })
        return VStack {
            AppList(athleticsPots,
                    placeHolder: "pots.noAthletics".localized,
                    commonPot: gameDoor.commonPot,
                    title: "pots.athleticsPots".localized,
                    helpText: "potsList")
                .environmentObject(gameDoor)
            HStack {
                Image(systemName: "exclamationmark.bubble.fill")
                Text("pots.warning".localized)
                Image(systemName: "checkmark.square.fill")
                    .inButton {
                        
                    }
            }
            .withLightSimpleFont()
            .inRectangle(.leading)
            .fixedSize(horizontal: false, vertical: true)
            
        }
        .inNavigationHome(title: "pots.title".localized)
    }
}
