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
    @State var image: UIImage?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        SettingsPageView(elements: [
                            .textField(text: "Name", value: $name, keyboardType: .default),
                            .athleticImagePicker(image: $image, rotation: athletic?.imageRotation ?? 0)],
                         title: name == "" ? "Athletic's creation" : "Athletic's settings") {

        }
/*
            VStack() {
                Divider()
                Text("Name")
                    .withTitleFont()
                TextField("Name", text: $name)
                    .withBigSimpleFont()
                Divider()
                Text("Image")
                    .withTitleFont()
                AthleticImageWithButtons(image: image, radius: ViewCommonSettings().commonHeight * 8, rotation: athletic?.imageRotation ?? 0)
                ConfirmButton {
                    mode.wrappedValue.dismiss()
                }
            }
        
        .inNavigationPageView(title: athletic == nil ? "Create athletic" : "Athletic settings")
 */
    }
}
