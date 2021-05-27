//
//  SportSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 Settings page used to create or modify a sport.
 */
struct SportSettings: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// The choosen name.
    @State private var name: String = ""
    /// The choosen icon.
    @State private var icon: String = "A"
    /// The choosen unity type.
    @State private var unity: [Sport.UnityType] = []
    /// The choosen points conversion
    @State private var pointsConversion: [String] = ["", "", ""]
    /// Boolean indicating whether the name is empty or not.
    @State private var isNameEmpty: Bool = false
    /// The choosen sport.
    private let sport: Sport?
    /// Boolean indication whether the button has to be disabled or not.
    private var confirmationButtonIsDisabled: Bool {
        isNameEmpty ||
            unity.count == 0 ||
            (unity[0] != .time && Int(pointsConversion[0]) ?? 0 == 0) ||
            (unity[0] == .time && pointsConversion.map({ Int($0) ?? 0 }).reduce(0, +) == 0)
    }
    /// All sport unities.
    private let unities: [Sport.UnityType] = [.count, .distance, .time, .oneShot]
    /// The choosen unity's index in unities.
    private var choosenUnity: Int? {
        if unity.count == 1 {
            for index in unities.indices {
                if unity[0] == unities[index] {
                    return index
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    // MARK: - Init
    
    init(_ sport: Sport? = nil) {
        self.sport = sport
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module to set the name
            SettingsTextfield(
                title: "all.name".localized,
                placeholder: "all.name".localized,
                value: $name,
                keyboard: .default,
                isWrong: $isNameEmpty,
                limits: (minCount: 1, maxCount: nil), limitsExplanations: (minCount: "sports.settings.limitName".localized, maxCount: nil))
            // module to pick an unity type
            SettingsCustomPicker(
                titleOne: "sports.details.unityTitle".localized,
                titleMany: "sports.details.unityTitle".localized,
                data: unities,
                selectedObjects: $unity,
                maximumSelection: 1,
                lineCount: 1)
            // module to set the unity type value
            SettingsSportValue(
                placeholder: "sports.settings.valuePlaceholder".localized,
                unity: unity.count == 1 ? unity[0] : nil,
                pointsConversion: $pointsConversion,
                caller: .sport)
            // module to pick an icon
            SettingsSportIconPicker($icon)
        }
        .onAppear {
            if let sport  = sport {
                self.name = sport.description
                self.icon = sport.icon ?? "A"
                self.unity = [sport.unityType]
                self.pointsConversion = sport.pointsConversionStringArray
            }
        }
        .inSettingsPage(
            name == "" ? "sports.settings.new".localized:"\(name)",
            game: _game,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "sportsSettings"
        ) {
            // confirmation button action
            guard unity.count == 1 else { return }
            if let sport = sport {
                game.modify(sport, name: name, icon: icon, unityType: unity[0], pointsConversion: pointsConversion)
            } else {
                game.addSport(name: name, icon: icon, unityType: unity[0], pointsConversion: pointsConversion)
            }
        }
    }
}
