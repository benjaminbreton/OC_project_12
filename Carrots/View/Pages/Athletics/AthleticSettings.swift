//
//  AthleticSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticSettings: View {
    
    // MARK: - Properties
    
    /// Viewmodel.
    @EnvironmentObject var gameDoor: GameDoor
    /// Choosen athletic ; nil in case of creation of a new one.
    let athletic: Athletic?
    /// Current name.
    @State var name: String
    /// Current image.
    @State var image: UIImage?
    @State var isNameEmpty: Bool = false
    var confirmationButtonIsDisabled: Bool { isNameEmpty }
    
    /// Current image's data.
    var data: Data? {
        image?.jpegData(compressionQuality: 1)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            SettingsTextfield(title: "all.name".localized, placeHolder: "all.name".localized, value: $name, keyboard: .default, explanations: nil, isWrong: $isNameEmpty, limits: (minCount: 1, maxCount: nil), limitsExplanations: (minCount: "athletics.settings.nameLimit".localized, maxCount: nil))
            SettingsAthleticImagePicker(image: $image)
        }
        .inSettingsPage(
            name == "" ? "athletics.settings.new".localized:"\(name)",
            gameDoor: _gameDoor,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "athleticsSettings",
            confirmAction: {
            if let athletic = athletic {
                gameDoor.modify(athletic, name: name, image: data)
            } else {
                gameDoor.addAthletic(name: name, image: data)
            }
        })
    }
    
}
