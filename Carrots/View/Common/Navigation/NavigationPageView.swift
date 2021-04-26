//
//  NavigationPageView.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct InNavigationHome<T: View>: ViewModifier {
    let title: String
    let buttonImage: String
    let buttonDestination: T
    func body(content: Content) -> some View {
        NavigationView {
            content
                .withAppBackground()
                .navigationBarTitle(Text(title))
                .navigationBarItems(trailing: NavigationBarButton(image: buttonImage, destination: buttonDestination))
        }
        .accentColor(.title)
    }
}

struct NavigationPageView: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text(title))
            .withAppBackground()
    }
}
extension View {
    func inNavigationHome<T: View>(title: String, buttonImage: String, buttonDestination: T) -> some View {
        modifier((InNavigationHome(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination)))
    }
}


