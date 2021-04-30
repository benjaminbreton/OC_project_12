//
//  NavigationPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct NavigationPageView: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text(title))
            .withAppBackground()
    }
}

// MARK: - View's extension

extension View {
    func inNavigationPageView(title: String) -> some View {
        modifier(NavigationPageView(title: title))
    }
}


