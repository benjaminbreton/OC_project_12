//
//  InDetailsPage.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
struct InDetailsPage<T: View>: ViewModifier {
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
        modifier(InDetailsPage(genericTitle: genericTitle, specificTitle: specificTitle, destinationToModify: destinationToModify))
    }
}




