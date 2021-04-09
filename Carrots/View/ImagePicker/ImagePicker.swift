//
//  ImagePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import UIKit
import SwiftUI
struct CustomActionSheetAlert: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIAlertController
    let message: String
    let buttons: [(title: String, action: () -> Void)]
    func makeUIViewController(context: Context) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        for buttonData in buttons {
            let button = UIAlertAction(title: buttonData.title, style: .default, handler: { _ in
                buttonData.action()
            })
            alert.addAction(button)
        }
        return alert
    }
    
    func updateUIViewController(_ uiViewController: UIAlertController, context: Context) {
        
    }
    
    
    
    
}
struct ImagePicker: UIViewControllerRepresentable {
    
    
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImageData: Data?
    @Environment(\.presentationMode) private var presentationMode
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
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
                parent.selectedImageData = image.pngData()
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


