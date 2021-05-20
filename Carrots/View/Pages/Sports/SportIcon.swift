//
//  SportIcon.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportIcon: View {
    var icon: String
    let lineCount: CGFloat
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.backCell)
            Text(icon)
                .withSportIconFont(lineCount: lineCount)
        }
    }
}
