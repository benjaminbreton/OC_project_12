//
//  SportIconPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI

// MARK: - Displayed module

struct SettingsSportIconPicker: View {
    
    // MARK: - Selected icon
    
    @Binding var icon: String
    
    // MARK: - Body
    
    var body: some View {
        SettingsSportIconScrollView(icon: _icon)
            .inModule("icon.title".localized)
    }
}

// MARK: - Icon scroll view

fileprivate struct SettingsSportIconScrollView: View {
    
    // MARK: - Properties
    
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
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(characters.indices) { index in
                    ZStack {
                        SportIcon(icon: characters[index], lineCount: 3)
                            .frame(width: ViewCommonSettings().textLineHeight * 3, height: ViewCommonSettings().textLineHeight * 3)
                            .inButton {
                                icon = characters[index]
                        }
                        Circle()
                            .stroke(lineWidth: ViewCommonSettings().strokeLineWidth)
                            .foregroundColor(.image)
                            .opacity(selection == index ? 1 : 0)
                    }
                }
            }
            .frame(height: ViewCommonSettings().textLineHeight * 4)
        }
    }
}
