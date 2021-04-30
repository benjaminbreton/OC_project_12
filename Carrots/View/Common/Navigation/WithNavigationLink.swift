//
//  NavigationLinkOnModifier.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct WithNavigationLink<T: View>: ViewModifier {
    let destination: T
    func body(content: Content) -> some View {
        NavigationLink(
            destination: destination,
            label: {
                content
            })
    }
}

// MARK: - View's extension

extension View {
    func withNavigationLink<T: View>(destination: T) -> some View {
        modifier(WithNavigationLink(destination: destination))
    }
}
