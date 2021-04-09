//
//  AthleticCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticCell: View {
    let athletic: FakeAthletic
    @State var rotation: Double = 0
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                AthleticImage(imageData: athletic.image, radius: ViewCommonSettings().commonHeight * 2, rotation: $rotation)
                Text(athletic.name ?? "No name")
                    .padding()
                    .withBigSimpleFont()
            }
        }
        .frame(height: ViewCommonSettings().commonHeight * 4)
        .withNavigationLink(destination: AthleticSettings(athletic: athletic, name: athletic.name ?? "Name"))
    }
}
