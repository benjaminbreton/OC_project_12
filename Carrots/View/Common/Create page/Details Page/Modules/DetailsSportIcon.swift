//
//  DetailsSportIcon.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/05/2021.
//

import SwiftUI
/**
 Module displaying a sport icon.
 */
struct DetailsSportIcon: View {
    
    // MARK: - Property
    
    /// Icon to display.
    private let icon: String
    
    // MARK: - Init
    
    init(icon: String) {
        self.icon = icon
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            VerticalSpacer()
            SportIcon(
                icon: icon,
                lineCount: 5
            )
            VerticalSpacer()
        }
        .inCenteredModule("icon.title".localized)
    }
}
