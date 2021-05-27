//
//  AthleticSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 Settings page used to create or modify an athletic.
 */
struct AthleticSettings: View {
    
    
    
    // MARK: - Properties
    
    /// Viewmodel.
    @EnvironmentObject private var game: GameViewModel
    /// Current name.
    @State private var name: String = ""
    /// Current image.
    @State private var image: UIImage? = nil
    /// Boolean indicating whether an error has to be displayed regarding the name, or not.
    @State private var isNameEmpty: Bool = false
    /// Choosen athletic ; nil in case of creation of a new one.
    private let athletic: Athletic?
    /// Boolean indicating whether the confirmation button has be disabled or not.
    private var confirmationButtonIsDisabled: Bool { isNameEmpty }
    /// Current image's data.
    private var data: Data? { image?.jpegData(compressionQuality: 1) }
    
    // MARK: - Init
    
    init(_ athletic: Athletic? = nil) {
        self.athletic = athletic
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module used to set the athletic's name
            SettingsTextfield(
                title: "all.name".localized,
                placeholder: "all.name".localized,
                value: $name,
                keyboard: .default,
                explanations: nil,
                isWrong: $isNameEmpty,
                limits: (minCount: 1, maxCount: nil),
                limitsExplanations: (minCount: "athletics.settings.nameLimit".localized, maxCount: nil)
            )
            // module used to pick an image
            SettingsAthleticImagePicker(
                image: $image
            )
        }
        .onAppear {
            if let athletic = athletic {
                self.name = athletic.description
                self.image = UIImage(data: athletic.image ?? Data())
            }
        }
        .inSettingsPage(
            name == "" ? "athletics.settings.new".localized:"\(name)",
            game: _game,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "athleticsSettings",
            confirmAction: {
                if let athletic = athletic {
                    game.modify(athletic, name: name, image: data)
                } else {
                    game.addAthletic(name: name, image: data)
                }
            }
        )
    }
}
