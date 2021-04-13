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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        let list = elements.map({ SettingsPageCell(element: $0) })
        return VStack {
            Divider().padding()
            ListBase(items: list)
            ConfirmButton {
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: title)
    }
    
}
struct SettingsPageCell: View {
    let element: Element
    enum Element {
        case textField(text: String, value: Binding<String>)
        case sportIconPicker(selected: Binding<Int>)
        case sportUnityPicker(allChoices: [Sport.UnityType], selected: Binding<Sport.UnityType>)
    }
    var body: some View {
        return VStack {
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

