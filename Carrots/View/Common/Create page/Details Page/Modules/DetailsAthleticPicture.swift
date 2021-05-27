//
//  DetailsAthleticPicture.swift
//  Carrots
//
//  Created by Benjamin Breton on 21/04/2021.
//

import SwiftUI
/**
 Display an athletic's picture in a module.
 */
struct DetailsAthleticPicture: View {
    
    // MARK: - Properties
    
    /// Image to display.
    private let image: UIImage?
    /// Radius used to determinate image's size.
    private let radius = UIScreen.main.bounds.width / 4
    
    // MARK: - Init
    
    init(image: UIImage?) {
        self.image = image
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            VerticalSpacer()
            AthleticImage(image: image, radius: radius)
                .inCenteredModule()
            VerticalSpacer(5)
        }
    }
}
