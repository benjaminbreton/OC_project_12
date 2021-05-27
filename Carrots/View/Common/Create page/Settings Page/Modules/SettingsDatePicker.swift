//
//  SettingsDatePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
/**
 Present a date picker in a settings module.
 */
struct SettingsDatePicker: View {
    
    // MARK: - Properties
    
    /// The selected date.
    @Binding var date: Date
    /// The module's title.
    let title: String
    /// The range in which the date can be choosen.
    let range: DateRange
    enum DateRange {
        case afterToday, beforeToday, any
    }
    /// Explanations to display about the choice.
    let explanations: String?
    
    // MARK: - Init
    
    init(title: String, date: Binding<Date>, range: DateRange, explanations: String? = nil) {
        self.title = title
        self._date = date
        self.range = range
        self.explanations = explanations
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            // display the date picker regarding the range
            switch range {
            case .afterToday:
                DatePicker(selection: _date, in: Date()..., displayedComponents: .date) {
                    Text("date.ask".localized)
                }
            case .beforeToday:
                DatePicker(selection: _date, in: ...Date(), displayedComponents: .date) {
                    Text("date.ask".localized)
                }
            case .any:
                DatePicker(selection: _date, displayedComponents: .date) {
                    Text("date.ask".localized)
                }
            }
        }
        .inModule(title, explanations: explanations)
    }
}
