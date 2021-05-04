//
//  SettingsSegmentedPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
struct SettingsSegmentedPicker: View {
    
    // MARK: - Properties
    
    let title: String
    @Binding var selection: Int
    let instructions: String
    let possibilities: [String]
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Picker(selection: _selection,
                   label: Text(instructions),
                   content: {
                    ForEach(possibilities.indices) { index in
                        Text(possibilities[index])
                            .tag(index)
                    }
            })
            .pickerStyle(SegmentedPickerStyle())
        }
        .frame(height: ViewCommonSettings().commonHeight * 4)
        .inModule(title)
        
    }
}
