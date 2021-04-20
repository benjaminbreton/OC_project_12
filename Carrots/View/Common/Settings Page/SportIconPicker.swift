//
//  SportIconPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
struct SportIconPicker: View {
    @Binding var icon: String
    var body: some View {
        VStack {
            Text("Icon")
                .withTitleFont()
            SportIconScrollView(icon: _icon)
        }
    }
}
struct SportIconScrollView: View {
    @Binding var icon: String
    private var selection: Int {
        for index in characters.indices {
            if characters[index] == icon {
                return index
            }
        }
        return 0
    }
    let characters: [String] = ViewCommonSettings().sportsIconsCharacters
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(characters.indices) { index in
                    ZStack {
                        SportIcon(icon: characters[index], multiplier: 6)
                            .frame(width: ViewCommonSettings().commonHeight * 6, height: ViewCommonSettings().commonHeight * 6)
                            .inButton {
                                icon = characters[index]
                        }
                        Circle()
                            .stroke(lineWidth: ViewCommonSettings().lineWidth)
                            .foregroundColor(.image)
                            .opacity(selection == index ? 1 : 0)
                    }
                }
            }
            .frame(height: ViewCommonSettings().commonHeight * 8)
        }
    }
}
