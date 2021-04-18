//
//  InSettingsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct InSettingsPage: ViewModifier {
    let title: String
    let confirmAction: () -> Void
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            //Divider().padding()
            ScrollView(.vertical) {
                content
            }
            ConfirmButton {
                confirmAction()
                mode.wrappedValue.dismiss()
            }
        }
        .inNavigationPageView(title: title)
    }
}
