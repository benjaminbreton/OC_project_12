//
//  CommonSpacers.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
fileprivate struct CommonSpacer: View {
    init(widthQuantity: CGFloat? = nil, heightQuantity: CGFloat? = nil) {
        self.widthQuantity = widthQuantity
        self.heightQuantity = heightQuantity
    }
    
    private let widthQuantity: CGFloat?
    private let heightQuantity: CGFloat?
    
    var body: some View {
        Spacer()
            .frame(
                width: widthQuantity == nil ? nil : ViewCommonSettings().commonSizeBase * (widthQuantity ?? 0),
                height: heightQuantity == nil ? nil :  ViewCommonSettings().commonSizeBase * (heightQuantity ?? 0))
    }
}
struct CommonHeightSpacer: View {
    let quantity: CGFloat
    init(_ quantity: CGFloat = 1) {
        self.quantity = quantity
    }
    var body: some View {
        CommonSpacer(heightQuantity: quantity)
    }
}
struct CommonWidthSpacer: View {
    let quantity: CGFloat
    init(_ quantity: CGFloat = 1) {
        self.quantity = quantity
    }
    var body: some View {
        CommonSpacer(widthQuantity: quantity)
    }
}
