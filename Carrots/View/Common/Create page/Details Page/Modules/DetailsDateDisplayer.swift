//
//  DetailsDateDisplayer.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
/**
 Display a date in a module.
 */
struct DetailsDateDisplayer: View {
    
    // MARK: - Properties
    
    /// Module's title.
    private let title: String
    /// Date to display.
    private let date: Date?
    /// Formatted date to display.
    private var formattedDate: String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // MARK: - Init
    
    init(title: String, date: Date?) {
        self.title = title
        self.date = date
    }
    
    // MARK: - Body
    
    var body: some View {
        Text(formattedDate)
            .inModule(title)
    }
}
