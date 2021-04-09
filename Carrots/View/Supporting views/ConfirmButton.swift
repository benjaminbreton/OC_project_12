//
//  ConfirmButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct ConfirmButton: View {
    let action: () -> Void
    var body: some View {
        VStack {
            Divider()
            Spacer()
                .frame(width: .none, height: ViewCommonSettings().spacerCommonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("Confirm")
                .inButton(action: action)
            Spacer()
                .frame(width: .none, height: ViewCommonSettings().spacerCommonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
        }
    }
}
