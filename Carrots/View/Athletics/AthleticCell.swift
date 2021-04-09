//
//  AthleticCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticCell: View {
    let athletic: FakeAthletic
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                GeometryReader { geometry in
                    AthleticImage(imageData: athletic.image, radius: geometry.size.height / 2)
                    //.frame(width: geometry.size.height, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Text(athletic.name ?? "No name")
                    .padding()
                    .withBigSimpleFont()
            }
        }
        .withNavigationLink(destination: AthleticSettings(athletic: athletic, name: athletic.name ?? "Name"))
    }
}
