//
//  AthleticImage.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticImage: View {
    let image: UIImage?
    let radius: CGFloat
    @Binding var rotation: Double
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.backCell)
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(.init(degrees: rotation))
                
            } else {
                Image(systemName: "person")
                    .resizable()
                    .foregroundColor(.image)
            }
        }
        .frame(width: radius * 2, height: radius * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .cornerRadius(radius)
    }
    
}



