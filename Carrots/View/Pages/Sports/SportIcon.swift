//
//  SportIcon.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportIcon: View {
    
    // MARK: - Properties
    
    /// The icon.
    private let icon: String
    /// The line count, aka the icon's size.
    private let lineCount: CGFloat
    
    // MARK: - Init
    
    init(icon: String, lineCount: CGFloat) {
        self.icon = icon
        self.lineCount = lineCount
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            // icon background
            Circle()
                .foregroundColor(.backCell)
            // selected icon
            Text(icon)
                .withSportIconFont(lineCount: lineCount)
        }
        .frame(width: ViewCommonSettings().textLineHeight * lineCount, height: ViewCommonSettings().textLineHeight * lineCount)
    }
}
