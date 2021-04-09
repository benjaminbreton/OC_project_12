//
//  AthleticSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticSettings: View {
    let athletic: FakeAthletic?
    @State var name: String
    @State var image: Data?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Divider()
                Text("Name")
                    .withTitleFont()
                TextField("Name", text: $name)
                    .withBigSimpleFont()
                Divider()
                Text("Image")
                    .withTitleFont()
                AthleticImageWithButtons(imageData: image, radius: geometry.size.width * 0.35)
                ConfirmButton {
                    mode.wrappedValue.dismiss()
                }
            }
        }
        .inNavigationPageView(title: athletic == nil ? "Create athletic" : "Athletic settings")
    }
}
