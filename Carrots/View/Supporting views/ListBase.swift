//
//  ListBase.swift
//  Carrots
//
//  Created by Benjamin Breton on 02/04/2021.
//

import SwiftUI
struct ListBase<T: View>: View {
    let items: [T]
    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = UIView()
        return List {
            ForEach(items.indices) { index in
                items[index]
            }
            .listRowBackground(Color.clear)
        }
    }
}
