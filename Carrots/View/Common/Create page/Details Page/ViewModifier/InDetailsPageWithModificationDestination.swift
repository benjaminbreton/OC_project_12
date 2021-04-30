//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
fileprivate struct InDetailsPageWithoutModificationDestination: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        VStack {
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageView(title: title)
    }
}
fileprivate struct InDetailsPageWithModificationDestination<T: View>: ViewModifier {
    let genericTitle: String
    let specificTitle: String
    let destinationToModify: T
    func body(content: Content) -> some View {
        VStack {
            Divider()
            HStack {
                Text(specificTitle)
                    .withBigTitleFont()
                Image(systemName: "square.and.pencil")
                    .withNavigationLink(destination: destinationToModify)
                    .withLinkFont()
            }
            Divider()
            ScrollView(.vertical) {
                content
            }
            Divider()
        }
        .inNavigationPageView(title: genericTitle)
    }
}
extension View {
    func inDetailsPage<T: View>(genericTitle: String, specificTitle: String, destinationToModify: T) -> some View {
        modifier(InDetailsPageWithModificationDestination(genericTitle: genericTitle, specificTitle: specificTitle, destinationToModify: destinationToModify))
    }
    func inDetailsPage(genericTitle: String) -> some View {
        modifier(InDetailsPageWithoutModificationDestination(title: genericTitle))
    }
}




