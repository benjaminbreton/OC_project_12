//
//  SportIconPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI

// MARK: - Displayed module

/**
 Settings module used to choose a sport's icon.
 */
struct SettingsSportIconPicker: View {
    
    // MARK: - Properties
    
    /// The selected icon.
    @Binding private var icon: String
    
    // MARK: - Init
    
    init(_ icon: Binding<String>) {
        self._icon = icon
    }
    
    // MARK: - Body
    
    var body: some View {
        SettingsSportIconScrollView(_icon)
            .inModule("icon.title".localized)
    }
}

// MARK: - Icon scroll view

/**
 Scroll view displaying icons to choose one of them.
 */
fileprivate struct SettingsSportIconScrollView: View {
    
    // MARK: - Properties
    
    /// The selected icon.
    @Binding private var icon: String
    /// The sected icon's index in characters.
    private var selection: Int {
        for index in characters.indices {
            if characters[index] == icon {
                return index
            }
        }
        return 0
    }
    /// All characters used as icons.
    private let characters: [String] = ViewCommonSettings().sportsIconsCharacters
    
    // MARK: - Init
    
    init(_ icon: Binding<String>) {
        self._icon = icon
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                // returns all characters as icons
                ForEach(characters.indices) { index in
                    ZStack {
                        // get the icon
                        SportIcon(icon: characters[index], lineCount: 3)
                            .inButton {
                                // set the icon as the selected icon
                                icon = characters[index]
                            }
                        // create a stroked circle for selected icon
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
