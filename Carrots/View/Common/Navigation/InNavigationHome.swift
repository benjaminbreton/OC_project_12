//
//  InNavigationHome.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import SwiftUI

// MARK: - ViewModifier

fileprivate struct InNavigationHome<T: View>: ViewModifier {
    let title: String
    let buttonImage: String
    let buttonDestination: T?
    @State var showAlert: Bool = false
    func body(content: Content) -> some View {
        NavigationView {
            content
                .withAppBackground()
                .navigationBarTitle(Text(title))
                .navigationBarItems(trailing: buttonDestination == nil ? nil : NavigationBarButton(image: buttonImage, destination: buttonDestination))
        }
        .accentColor(.title)
    }
}

// MARK: - View's extension

extension View {
    func inNavigationHome<T: View>(title: String, buttonImage: String, buttonDestination: T?) -> some View {
        modifier((InNavigationHome(title: title, buttonImage: buttonImage, buttonDestination: buttonDestination)))
    }
}


