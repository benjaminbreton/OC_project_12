//
//  NavigationLinkOnModifier.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct WithNavigationLink<T: View>: ViewModifier {
    let destination: T
    func body(content: Content) -> some View {
        NavigationLink(
            destination: destination,
            label: {
                content
            })
    }
}
