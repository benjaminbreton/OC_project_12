//
//  InNavigationBarButton.swift
//  Carrots
//
//  Created by Benjamin Breton on 20/04/2021.
//

import SwiftUI
/**
 The button used in navigation bars.
 */
struct NavigationBarButton<T: View>: View {
    
    // MARK: - Properties
    
    /// Button's image's system name.
    private let image: String
    /// The destination to reach when the button is hitten.
    private let destination: T
    
    // MARK: - Init
    
    init(image: String, destination: T) {
        self.image = image
        self.destination = destination
    }
    
    // MARK: - Body
    
    var body: some View {
        Image(systemName: image)
            .withNavigationButtonFont()
            .inNavigationLink(destination)
    }
}
