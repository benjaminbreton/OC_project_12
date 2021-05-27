//
//  AthleticImagePicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/04/2021.
//

import SwiftUI
import UIKit

// MARK: - Displayed module

/**
 Settings module used to choose an athletic's image.
 */
struct SettingsAthleticImagePicker: View {
    
    // MARK: - Properties
    
    /// Selected image
    @Binding private var image: UIImage?
    /// Boolean indicating whether the picker is shown, or not.
    @State private var isShowPicker: Bool = false
    /// Source of the image.
    @State private var source: UIImagePickerController.SourceType? {
        didSet {
            // when the source is selected, present the picker
            isShowPicker = true
        }
    }
    /// Radius used to determinate image's size.
    private let radius: CGFloat = ViewCommonSettings().commonSizeBase * 8
    
    // MARK: - Init
    
    init(image: Binding<UIImage?>) {
        self._image = image
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            // selected image
            AthleticImage(image: image, radius: radius)
            // buttons to select an image ...
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    // ... in the phone's library
                    AthleticImageButton("photo") {
                        self.source = .photoLibrary
                    }
                    Spacer()
                    // ... with the camera
                    AthleticImageButton("camera") {
                        self.source = .camera
                    }
                }
            }
        }
        // present the UIPicker regarding the source
        .sheet(isPresented: $isShowPicker, content: {
            ImagePicker(sourceType: $source, selectedImage: $image)
        })
        .inCenteredModule("image.title".localized)
    }
}

// MARK: - Athletic Image Button

/**
 Buttons to select a picker : library or camera.
 */
fileprivate struct AthleticImageButton: View {
    
    // MARK: - Properties
    
    /// Button's picture's name.
    private let name: String
    /// Action to perform when button is hitten.
    private let action: () -> Void
    
    // MARK: - Init
    
    init(_ name: String, action: @escaping () -> Void) {
        self.name = name
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Image(systemName: name)
            .withAthleticImageButtonFont()
            .inButton(action: action)
    }
}

// MARK: - UIImagePicker

/**
 View builded with an UIImagePickerController.
 */
fileprivate struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    /// Used to dismiss picker.
    @Environment(\.presentationMode) private var presentationMode
    /// The selected source by the user : library or camera.
    @Binding var sourceType: UIImagePickerController.SourceType?
    /// The selected image.
    @Binding var selectedImage: UIImage?
    
    // MARK: - Init
    
    init(sourceType: Binding<UIImagePickerController.SourceType?>, selectedImage: Binding<UIImage?>) {
        self._sourceType = sourceType
        self._selectedImage = selectedImage
    }
    
    // MARK: - UIViewController
    
    /**
     Create the picker with the selected source.
     */
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType ?? .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    /**
     Update the picker.
     */
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    // MARK: - Coordinator
    
    /**
     Create the coordinator.
     */
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    /**
     Picker's coordinator, used to know when an image has been selected.
     */
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - Properties
        
        /// Coordinator's parent, aka the picker.
        private var parent: ImagePicker
        
        // MARK: - Init
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // MARK: - PickerController
        
        /**
         Method called when an image has been selected.
         */
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // get the image
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // set the selected image as the parent's selected image
                parent.selectedImage = image
            }
            // dismiss the picker
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}







