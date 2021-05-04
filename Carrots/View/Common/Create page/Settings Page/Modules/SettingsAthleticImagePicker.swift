//
//  AthleticImagePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
import UIKit

struct SettingsAthleticImagePicker: View {
    @Binding var image: UIImage?
    var body: some View {
        AthleticImageWithButtons(image: _image, radius: ViewCommonSettings().commonHeight * 8)
            .inCenteredSettingsModule("Image")
    }
}
fileprivate struct AthleticImageWithButtons: View {
    @Binding var image: UIImage?
    let radius: CGFloat
    @State private var isShowPicker: Bool = false
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

fileprivate struct AthleticImageButton: View {
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

fileprivate struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var sourceType: UIImagePickerController.SourceType?
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType ?? .camera
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}







