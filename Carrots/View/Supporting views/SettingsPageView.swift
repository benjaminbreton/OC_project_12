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
        case textField(text: String, value: Binding<String>, keyboardType: UIKeyboardType)
        case sportIconPicker(selected: Binding<Int>)
        case sportUnityPicker(allChoices: [Sport.UnityType], selected: Binding<Sport.UnityType>)
        case athleticImagePicker(image: Binding<UIImage?>, rotation: Double)
        case sportUnityValue(selected: Sport.UnityType, valueForOnePoint: Binding<[String]>)
    }
    var body: some View {
        return VStack(alignment: .center) {
            switch element {
            case .textField(text: let title, value: let value, keyboardType: let keyboard):
                Text(title)
                    .withTitleFont()
                TextField(title, text: value)
                    .keyboardType(keyboard)
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
            case .sportUnityValue(selected: let selected, valueForOnePoint: let value):
                Text("Value for 1 point")
                    .withTitleFont()
                switch selected {
                case .time:
                    HStack {
                        TextField("Value", text: value[0])
                            .keyboardType(.numberPad)
                            .withBigSimpleFont()
                        Text(" h ")
                        TextField("Value", text: value[1])
                            .keyboardType(.numberPad)
                            .withBigSimpleFont()
                        Text(" m ")
                        TextField("Value", text: value[2])
                            .keyboardType(.numberPad)
                            .withBigSimpleFont()
                        Text(" s ")
                        
                    }
                default:
                    TextField("Value", text: value[0])
                        .withBigSimpleFont()
                }
            }
        }
    }
}
struct GenericTextfield: View {
    let title: String
    var value: Binding<String>
    let keyboard: UIKeyboardType
    var body: some View {
        VStack {
            Text(title)
                .withTitleFont()
            TextField(title, text: value)
                .keyboardType(keyboard)
                .withBigSimpleFont()
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

