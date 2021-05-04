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
        AppList(viewModel.athletics, placeHolder: """
                    No athletics have been added.

                    To add an athletic, press the + button on the top of the screen, and set athletic's informations.
                    """)
//        VStack {
//            Divider()
//            if viewModel.athletics.count > 0 {
//                ListBase(items: viewModel.athletics.map({
//                    AthleticCell(athletic: $0)
//                }))
//            } else {
//                Text("""
//                    No athletics have been added.
//
//                    To add an athletic, press the + button on the top of the screen, and set athletic's informations.
//                    """)
//                    .withSimpleFont()
//                    .inRectangle(.topLeading)
//            }
//            Divider()
//        }
        .inNavigationHome(title: "athletics", buttonImage: "person.crop.circle.badge.plus", buttonDestination: AthleticSettings(athletic: nil, name: "", image: nil))
    }
}
class AthleticGame: ObservableObject {
    
}
