//
//  SettingsSegmentedPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
/**
 Present a segmented picker in a settings module.
 */
struct SettingsSegmentedPicker: View {
     
    // MARK: - Properties
    
    /// The selected segment.
    @Binding private var selection: Int
    /// The module's title.
    private let title: String
    /// Instructions about the segmented picker.
    private let instructions: String
    /// Choices user can made.
    private let possibilities: [String]
    
    // MARK: - Init
    
    init(_ selection: Binding<Int>, title: String, instructions: String, possibilities: [String]) {
        self._selection = selection
       self.title = title
       self.instructions = instructions
       self.possibilities = possibilities
   }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // the picker
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
        .frame(height: ViewCommonSettings().commonSizeBase * 4)
        .inModule(title)
    }
}
