//
//  WithBackground.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
fileprivate struct WithBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.backgroundFirst, .backgroundSecond]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            content
                .zIndex(1)
        }
    }
}
extension View {
    func withAppBackground() -> some View {
        modifier(WithBackground())
    }
}
