//
//  InNavigationBarButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
struct NavigationBarButton<T: View>: View {
    let image: String
    let destination: T
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.link)
            .font(.largeTitle)
            .withNavigationLink(destination: destination)
    }
}
