//
//  AthleticImage.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticImage: View {
    let imageData: Data?
    let radius: CGFloat
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .foregroundColor(.white)
                .opacity(0.2)
            if let data = imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "person")
                    .resizable()
                    .foregroundColor(.orange)
            }
        }
        .frame(width: radius * 2, height: radius * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .cornerRadius(radius)
    }

}
struct AthleticImageWithButtons: View {
    @State var imageData: Data?
    let radius: CGFloat
    @State private var isShowPicker = false
    @State private var isShowCamera = false
    var body: some View {
        ZStack(alignment: .center) {
            AthleticImage(imageData: imageData, radius: radius)
            VStack {
                Spacer()
                    .frame(width: radius * 2, height: radius * 1.7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
            ImagePicker(sourceType: isShowCamera ? .camera : .photoLibrary, selectedImageData: $imageData)
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
                    .foregroundColor(.white)
                Image(systemName: name)
                    .resizable()
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
            }
        }
        
    }
}


