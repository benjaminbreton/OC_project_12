//
//  DetailsAthleticPicture.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
struct DetailsAthleticPicture: View {
    let image: UIImage?
    let radius = UIScreen.main.bounds.width / 4
    var body: some View {
        VStack {
            CommonHeightSpacer()
            AthleticImage(image: image, radius: radius)
                .inCenteredModule()
            CommonHeightSpacer(5)
        }
    }
}
