//
//  DetailsDateDisplayer.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
struct DetailsDateDisplayer: View {
    let title: String
    let date: Date?
    var formattedCreationDate: String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    var body: some View {
        Text(formattedCreationDate)
            .inModule(title)
    }
}
