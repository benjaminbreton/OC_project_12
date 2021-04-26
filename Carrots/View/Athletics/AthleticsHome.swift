//
//  AthleticsHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct AthleticsHome: View {
    let viewModel: FakeViewModel
    var body: some View {
        VStack {
            Divider()
            if viewModel.athletics.count > 0 {
                ListBase(items: viewModel.athletics.map({
                    AthleticCell(athletic: $0)
                }))
            } else {
                Text("""
                    No athletics have been added.

                    To add an athletic, press the + button on the top of the screen, and set athletic's informations.
                    """)
                    .withSimpleFont()
                    .inRectangle(.topLeading)
            }
            Divider()
        }
        .inNavigationHome(title: "athletics", buttonImage: "person.crop.circle.badge.plus", buttonDestination: AthleticSettings(athletic: nil, name: "", image: nil))
    }
}

struct AppList<T: View>: View {
    let items: [T]
    var body: some View {
        ScrollView(.vertical) {
            ForEach(items.indices) { index in
                items[index]
                    .inRectangle(.leading)
            }
        }
        .lineSpacing(5)
    }
}
