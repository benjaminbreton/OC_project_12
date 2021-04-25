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
    @Binding var image: UIImage?
    let radius: CGFloat
    @State private var isShowPicker: Bool = false
    @State private var isShowCamera: Bool = false {
        didSet {
            isShowPicker = true
        }
    }
    @State var rotation: Double = 0
    @State private var source: UIImagePickerController.SourceType? {
        didSet {
            isShowPicker = true
        }
    }
    var body: some View {
        let sizeMultiplier: CGFloat = 0.4
        return ZStack(alignment: .center) {
            AthleticImage(image: image, radius: radius, rotation: $rotation)
            VStack(alignment: .center) {
                Spacer()
                    .frame(width: radius * 2, height: radius * 1.7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack {
                    AthleticImageButton("photo") {
                        self.source = .photoLibrary
                    }
                    Spacer()
                        .frame(width: radius * (2 - sizeMultiplier * 2), height: radius * 0.3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    AthleticImageButton("camera") {
                        self.source = .camera
                    }
                }
            }
            .frame(width: radius * 2, height: radius * 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .sheet(isPresented: $isShowPicker, content: {
            ImagePicker(sourceType: $source, selectedImage: $image)
        })
    }
}

struct AthleticImageButton: View {
    let name: String
    let action: () -> Void
    init(_ name: String, action: @escaping () -> Void) {
        self.name = name
        self.action = action
    }
    var body: some View {
        Image(systemName: name)
            .resizable()
            .font(.largeTitle)
            .foregroundColor(.link)
            .inButton(action: action)
    }
}


