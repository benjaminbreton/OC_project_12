//
//  CommonSpacers.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI

// MARK: - CommonSpacer

/**
 Spacer with special responsive size getted from the ViewCommonSettings.
 */
fileprivate struct CommonSpacer: View {
    
    // MARK: - Properties
    
    /// Quantity of spacers in the horizontal axis.
    private let widthQuantity: CGFloat?
    /// Quantity of spacers in the vertical axis.
    private let heightQuantity: CGFloat?
    
    // MARK: - Init
    
    init(widthQuantity: CGFloat? = nil, heightQuantity: CGFloat? = nil) {
        self.widthQuantity = widthQuantity
        self.heightQuantity = heightQuantity
    }
    
    // MARK: - Body
    
    var body: some View {
        Spacer()
            .frame(
                width: widthQuantity == nil ? nil : ViewCommonSettings().commonSizeBase * (widthQuantity ?? 0),
                height: heightQuantity == nil ? nil :  ViewCommonSettings().commonSizeBase * (heightQuantity ?? 0)
            )
    }
}

// MARK: - VerticalSpacer

/**
 Vertical spacer with special responsive size getted from the ViewCommonSettings.
 */
struct VerticalSpacer: View {
    
    // MARK: - Property
    
    /// Quantity of spacers.
    private let quantity: CGFloat
    
    // MARK: - Init
    
    init(_ quantity: CGFloat = 1) {
        self.quantity = quantity
    }
    
    // MARK: - Body
    
    var body: some View {
        CommonSpacer(heightQuantity: quantity)
    }
}

// MARK: - HorizontalSpacer

/**
 Horizontal spacer with special responsive size getted from the ViewCommonSettings.
 */
struct HorizontalSpacer: View {
    
    // MARK: - Property
    
    /// Quantity of spacers.
    private let quantity: CGFloat
    
    // MARK: - Init
    
    init(_ quantity: CGFloat = 1) {
        self.quantity = quantity
    }
    
    // MARK: - Body
    
    var body: some View {
        CommonSpacer(widthQuantity: quantity)
    }
}
