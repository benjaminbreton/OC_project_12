//
//  NavigationPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct NavigationPageView: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        ZStack(alignment: .topLeading) {
            Group {
                content
            }
        }
        .navigationBarTitle(Text(title))
        .padding()
        .withAppBackground()
    }
}

