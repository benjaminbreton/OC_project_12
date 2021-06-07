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
    @Binding private var date: Date
    /// The module's title.
    private let title: String
    /// The range in which the date can be choosen.
    private let range: DateRange
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
                DatePicker(selection: _date, in: Date().tomorrow..., displayedComponents: .date) {
                    Text("date.ask".localized)
                }
                .fixedSize(horizontal: false, vertical: true)
            case .beforeToday:
                DatePicker(selection: _date, in: ...Date().yesterday, displayedComponents: .date) {
                    Text("date.ask".localized)
                }
                .fixedSize(horizontal: false, vertical: true)
            case .any:
                DatePicker(selection: _date, displayedComponents: .date) {
                    Text("date.ask".localized)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .inModule(title, explanations: explanations)
    }
}
