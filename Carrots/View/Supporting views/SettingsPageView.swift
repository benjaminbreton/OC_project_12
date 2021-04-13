//
//  SettingsPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI



struct SettingsPageView: View {
    let elements: [SettingsPageCell.Element]
    let title: String
    let confirmAction: () -> Void
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        let list = elements.map({ SettingsPageCell(element: $0) })
        return VStack(alignment: .center) {
            //Divider().padding()
            SettingsScroll(items: list)
            ConfirmButton {
                confirmAction()
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: title)
    }
    
}
struct SettingsScroll<T: View>: View {
    let items: [T]
    var body: some View {
        ScrollView(.vertical) {
            ForEach(items.indices) { index in
                items[index]
            }
        }
    }
}
struct SettingsPageCell: View {
    let element: Element
    enum Element {
        case textField(text: String, value: Binding<String>)
        case sportIconPicker(selected: Binding<Int>)
        case sportUnityPicker(allChoices: [Sport.UnityType], selected: Binding<Sport.UnityType>)
        case athleticImagePicker(image: Binding<UIImage?>, rotation: Double)
    }
    var body: some View {
        return VStack(alignment: .center) {
            switch element {
            case .textField(text: let text, value: let value):
                Text(text)
                    .withTitleFont()
                TextField(text, text: value)
                    .withBigSimpleFont()
            case .sportIconPicker(selected: let selected):
                Text("Icon")
                    .withTitleFont()
                SportIconScrollView(selection: selected.wrappedValue)
                
            case .sportUnityPicker(allChoices: let unities, selected: let selected):
                Text("Unity")
                    .withTitleFont()
                GenericPicker(instructions: "Please choose an unity :", allChoices: unities, selected: selected)
            case .athleticImagePicker(image: let image, rotation: let rotation):
                Text("Image")
                    .withTitleFont()
                AthleticImageWithButtons(image: image, radius: ViewCommonSettings().commonHeight * 8, rotation: rotation)
            }
        }
    }
}
protocol HashableCustomString: Hashable, CustomStringConvertible { }
struct GenericPicker<ElementType: HashableCustomString>: View {
    let instructions: String
    let allChoices: [ElementType]
    let selected: Binding<ElementType>
    var body: some View {
        Picker("Please choose an unity", selection: selected) {
            ForEach(allChoices, id: \.self) {
                Text($0.description)
                    .withSimpleFont()
            }
        }.frame(height: ViewCommonSettings().commonHeight * 5)
    }
}

