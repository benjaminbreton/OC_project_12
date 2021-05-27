//
//  PotsWarning.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/05/2021.
//

import Foundation
import SwiftUI
/**
 A warning appearing when a pots list is displayed for the first time. When user accepts it, this warning will never appear again.
 */
struct PotsWarning: View {
    
    // MARK: - Property
    
    /// The ViewModel.
    @EnvironmentObject var game: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
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
