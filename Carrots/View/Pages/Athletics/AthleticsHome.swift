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
                    """, helpText: """
                        This page shows you the list of athletics.

                        By choosing the plus button, you can add an athletic.

                        By choosing an athletic, you can see his statistics and modify him.

                        By stay pressed on an athletic, you can delete him.
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
