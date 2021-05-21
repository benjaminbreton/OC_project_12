//
//  PotsWarning.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/05/2021.
//

import Foundation
import SwiftUI
struct PotsWarning: View {
    @EnvironmentObject var gameDoor: GameDoor
    var body: some View {
        Group {
            if gameDoor.athletics.count > 0 && !gameDoor.didValidateWarning {
                HStack {
                    Image(systemName: "exclamationmark.bubble.fill")
                    Text("pots.warning".localized)
                    Image(systemName: "checkmark.square.fill")
                        .inButton {
                            gameDoor.validateWarning()
                        }
                }
                .withLightSimpleFont()
                .inRectangle(.leading)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
