//
//  ConfirmButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct ConfirmButton: View {
    let action: () -> Void
    var isDisabled: Bool?
    init(isDisabled: Bool? = nil, action: @escaping () -> Void) {
        self.action = action
        self.isDisabled = isDisabled
    }
    var body: some View {
        VStack {
            Divider()
            Spacer()
                .frame(width: .none, height: ViewCommonSettings().commonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("confirmation.title".localized)
                .inButton(isDisabled: isDisabled, action: action)
            Spacer()
                .frame(width: .none, height: ViewCommonSettings().commonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
        }
    }
}
