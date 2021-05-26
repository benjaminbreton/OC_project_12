//
//  PotsWarning.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/05/2021.
//

import Foundation
import SwiftUI
struct PotsWarning: View {
    @EnvironmentObject var game: GameViewModel
    var body: some View {
        Group {
            if game.athletics.count > 0 && !game.didValidateWarning {
                HStack {
                    Image(systemName: "exclamationmark.bubble.fill")
                    Text("pots.warning".localized)
                    Image(systemName: "checkmark.square.fill")
                        .inButton {
                            game.validateWarning()
                        }
                }
                .withLightSimpleFont()
                .inRectangle(.leading)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
