//
//  SettingsDatePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI
struct SettingsDatePicker: View {
    
    // MARK: - Properties
    
    let title: String
    @Binding var date: Date
    let range: DateRange
    let explanations: String?
    enum DateRange {
        case afterToday, beforeToday, any
    }
    
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
            switch range {
            case .afterToday:
                DatePicker(selection: _date, in: Date()..., displayedComponents: .date) {
                    Text("Select a date")
                }
            case .beforeToday:
                DatePicker(selection: _date, in: ...Date(), displayedComponents: .date) {
                    Text("Select a date")
                }
            case .any:
                DatePicker(selection: _date, displayedComponents: .date) {
                    Text("Select a date")
                }
            }
        }
        .inModule(title, explanations: explanations)
    }
}
