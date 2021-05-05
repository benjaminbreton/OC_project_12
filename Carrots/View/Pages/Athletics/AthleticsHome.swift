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
        AppList(gameDoor.athletics, placeHolder: """
                    No athletics have been added.

                    To add an athletic, press the + button on the top of the screen, and set athletic's informations.
                    """)
            .environmentObject(gameDoor)
            .inNavigationHome(
                title: "athletics",
                buttonImage: "person.crop.circle.badge.plus",
                buttonDestination: AthleticSettings(athletic: nil, name: "", image: nil)
                    .environmentObject(gameDoor)
            )
    }
}
