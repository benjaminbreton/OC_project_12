//
//  CommonSpacers.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct CommonHeightSpacer: View {
    let quantity: Int
    init(_ quantity: Int = 1) {
        self.quantity = quantity
    }
    var body: some View {
        let array = Array.init(repeating: Spacer()
                                .frame(height: ViewCommonSettings().commonHeight), count: quantity)
        return VStack {
            ForEach(array.indices) { index in
                array[index]
            }
        }
        
    }
}
struct CommonWidthSpacer: View {
    var body: some View {
        Spacer()
            .frame(width: ViewCommonSettings().commonHeight)
    }
}
