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
        return List {
            ForEach(items.indices) { index in
                items[index]
            }
            .listRowBackground(Color.clear)
        }
    }
}
