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
                Text("Name : ")
                    .withSimpleFont()
                TextField("Name : ", text: $name)
                    .withTitleFont()
                Divider()
                AthleticImageWithButtons(imageData: image, radius: geometry.size.width * 0.35)
                //AthleticImage(imageData: image, radius: geometry.size.width / 2)
                Divider()
                Text(athletic != nil ? "Confirm" : "Add")
                    .inButton {
                        mode.wrappedValue.dismiss()
                    }
                Divider()
            }
        }
        .inNavigationPageView(title: "Settings")
    }
}
