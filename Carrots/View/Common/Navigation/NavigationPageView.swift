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
                .inNavigationPageViewWithButton(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination)
        }
        .accentColor(.title)
    }
}

struct NavigationPageView: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        content
        .navigationBarTitle(Text(title))
        //.padding()
        .withAppBackground()
        .closeKeyboardOnTap()
    }
}
struct NavigationPageViewWithButton<T: View>: ViewModifier {
    let title: String
    let buttonImage: String
    let buttonDestination: T
    func body(content: Content) -> some View {
        content
            .closeKeyboardOnTap()
            .withAppBackground()
            .navigationBarTitle(Text(title))
            .navigationBarItems(trailing: NavigationBarButton(image: buttonImage, destination: buttonDestination))
    }
}
extension View {
    func inNavigationPageViewWithButton<T: View>(title: String, buttonImage: String, buttonDestination: T) -> some View {
        modifier(NavigationPageViewWithButton(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination))
    }
    func inNavigationHome<T: View>(title: String, buttonImage: String, buttonDestination: T) -> some View {
        modifier((InNavigationHome(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination)))
    }
}


