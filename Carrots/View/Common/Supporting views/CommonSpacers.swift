//
//  CommonSpacers.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct CommonHeightSpacer: View {
    let quantity: CGFloat
    init(_ quantity: CGFloat = 1) {
        self.quantity = quantity
    }
    var body: some View {
        Spacer()
            .frame(height: ViewCommonSettings().commonHeight * quantity)
        
    }
}
struct CommonWidthSpacer: View {
    var body: some View {
        Spacer()
            .frame(width: ViewCommonSettings().commonHeight)
    }
}
