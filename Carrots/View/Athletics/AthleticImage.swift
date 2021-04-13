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
struct AthleticImageWithButtons: View {
    @State var image: UIImage?
    let radius: CGFloat
    @State private var isShowPicker = false
    @State private var isShowCamera = false
    @State var rotation: Double
    var body: some View {
        ZStack(alignment: .center) {
            AthleticImage(image: image, radius: radius, rotation: $rotation)
            VStack {
                // arrowshape.turn.up.left
                HStack {
                    SystemImageBlackAndWhite(name: "arrowshape.turn.up.left")
                        .inButton {
                            rotation -= 90
                        }
                    Spacer()
                        .frame(width: radius * 1.2, height: radius * 0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    SystemImageBlackAndWhite(name: "arrowshape.turn.up.right")
                        .inButton {
                            rotation += 90
                        }
                }
                Spacer()
                    .frame(width: radius * 2, height: radius * 1.4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack {
                    SystemImageBlackAndWhite(name: "photo")
                        .inButton {
                            isShowCamera = false
                            isShowPicker = true
                        }
                    Spacer()
                        .frame(width: radius * 1.2, height: radius * 0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    SystemImageBlackAndWhite(name: "camera")
                        .inButton {
                            isShowCamera = true
                            isShowPicker = true
                        }
                }
            }
            .frame(width: radius * 2, height: radius * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .sheet(isPresented: $isShowPicker, content: {
            ImagePicker(sourceType: isShowCamera ? .camera : .photoLibrary, selectedImage: $image)
        })
    }

}
struct SystemImageBlackAndWhite: View {
    let name: String
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Image(systemName: name)
                    .resizable()
                    .foregroundColor(.linkInverse)
                Image(systemName: name)
                    .resizable()
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.link)
            }
        }
        
    }
}


