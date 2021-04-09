//
//  SportIconScrollView.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportIconScrollView: View {
    @State var selection: Int
    let characters: [String] = ViewCommonSettings().sportsIconsCharacters
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(characters.indices) { index in
                    SportIcon(icon: characters[index], multiplier: 6)
                        .frame(width: ViewCommonSettings().commonHeight * 6, height: ViewCommonSettings().commonHeight * 6)
                        .inButton {
                            selection = index
                        }
                        .foregroundColor(selection == index ? .image : .text)
                }
            }
        }
    }
}
