//
//  AthleticsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct AthleticsHome: View {
    
    // MARK: - Properties
    
    /// View model.
    @EnvironmentObject var gameDoor: GameDoor
    
    // MARK: - Body
    
    var body: some View {
        AppList(gameDoor.athletics, placeHolder: "athletics.none".localized, helpText: "athleticsList")
            .inNavigationHome(
                title: "athletics.title".localized,
                buttonImage: "person.crop.circle.badge.plus",
                buttonDestination: AthleticSettings(athletic: nil, name: "", image: nil)
            )
    }
}
