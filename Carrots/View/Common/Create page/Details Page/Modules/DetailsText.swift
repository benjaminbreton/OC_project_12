//
//  DetailsText.swift
//  Carrots
//
//  Created by Benjamin Breton on 28/04/2021.
//

import SwiftUI
struct DetailsText: View {
    let title: String
    let texts: [String: String]
    var keys: [String] {
        texts.keys.map({ "\($0.description)" })
    }
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            ForEach(keys.indices) { index in
                HStack {
                    Text(keys[index])
                    Text(texts[keys[index]] ?? "")
                }
                .withSimpleFont()
                .inRectangle(.leading)
            }
        }
    }
}
