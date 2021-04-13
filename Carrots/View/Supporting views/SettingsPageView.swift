//
//  SettingsPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 13/04/2021.
//

import SwiftUI

protocol HashableCustomString: Hashable, CustomStringConvertible { }

struct SettingsPageView<ElementType: HashableCustomString>: View {
    let elements: [SettingsPageCell<ElementType>.Element<ElementType>]
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
struct SettingsPageCell<ElementType: HashableCustomString>: View {
    let element: Element<ElementType>
    enum Element<ElementType: HashableCustomString> {
        case textField(text: String, value: Binding<String>)
        case sportIconPicker(selected: Binding<Int>)
        case genericPicker(allChoices: [ElementType], selected: Binding<ElementType>, title: String)
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
                
            case .genericPicker(allChoices: let unities, selected: let selected, title: let title):
                Text(title)
                    .withTitleFont()
                Picker("Please choose an unity", selection: selected) {
                    ForEach(unities, id: \.self) {
                        Text($0.description)
                            .withSimpleFont()
                    }
                }.frame(height: ViewCommonSettings().commonHeight * 5)
            }
        }
    }
}

