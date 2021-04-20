//
//  CommonSpacers.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct CommonHeightSpacer: View {
    var body: some View {
        Spacer()
            .frame(height: ViewCommonSettings().commonHeight)
    }
}
struct CommonWidthSpacer: View {
    var body: some View {
        Spacer()
            .frame(width: ViewCommonSettings().commonHeight)
    }
}
