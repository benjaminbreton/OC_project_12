//
//  AthleticImage.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 The image to display for an athletic.
 */
struct AthleticImage: View {
    
    // MARK: - Properties
    
    private let image: UIImage?
    private let radius: CGFloat
    
    // MARK: - Init
    
    init(image: UIImage?, radius: CGFloat) {
        self.image = image
        self.radius = radius
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            // background
            Circle()
                .foregroundColor(.backCell)
            // foreground ...
            if let image = image {
                // ... if image has been choosen
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                // ... if no image : display person by default
                Image(systemName: "person")
                    .resizable()
                    .foregroundColor(.image)
            }
        }
        .frame(width: radius * 2, height: radius * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .cornerRadius(radius)
    }
    
}



