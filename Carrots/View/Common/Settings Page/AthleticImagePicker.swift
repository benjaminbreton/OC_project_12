//
//  AthleticImagePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
struct AthleticImagePicker: View {
    @Binding var image: UIImage?
    var body: some View {
        VStack {
            Text("Image")
                .withTitleFont()
            AthleticImageWithButtons(image: _image, radius: ViewCommonSettings().commonHeight * 8)
        }
    }
}
