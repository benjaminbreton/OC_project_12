//
//  PerformanceSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
/**
 Settings page used to create a performance.
 */
struct PerformanceSettings: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Selected athletics.
    @State private var selectedAthletics: [Athletic] = []
    /// Selected sport.
    @State private var selectedSport: [Sport] = []
    /// Selected performance's value.
    @State private var value: [String] = ["", "", ""]
    /// Boolean indicating whether the points have to be added to the common pot or not.
    @State private var addToCommonPot: Bool = true
    /// All sports.
    private var sportsArray: [Sport] { game.sports }
    /// All athletics.
    private var athleticsArray: [Athletic] { game.athletics }
    /// Boolean indicating whether the confirmation button has to be disabled or not.
    private var confirmationButtonIsDisabled: Bool {
        // 3 conditions for the button to be disabled (only one can disable the button) :
        // 1. no athletics have been selected
        selectedAthletics.count == 0 ||
            // 2. no sport has been selected
            selectedSport.count != 1 ||
            // 3. the sport's unity type is not one shot and ...
            (selectedSport[0].unityInt16.sportUnityType != .oneShot &&
                (
                    // ... it's not time and the first value is empty or null
                    (selectedSport[0].unityInt16.sportUnityType != .time && Int(value[0]) ?? 0 == 0) ||
                        // ... it's time and all values are empty or null
                        (selectedSport[0].unityInt16.sportUnityType == .time && value.map({ Int($0) ?? 0 }).reduce(0, +) == 0)
                )
            )
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // module to choose athletics
            SettingsCustomPicker(
                titleOne: "athletics.title.sing.maj".localized,
                titleMany: "athletics.title.maj".localized,
                data: athleticsArray,
                selectedObjects: $selectedAthletics,
                maximumSelection: 0,
                lineCount: 2)
            // module to choose a sport
            SettingsCustomPicker(
                titleOne: "sports.title.sing.maj".localized,
                titleMany: "sports.title.sing.maj".localized,
                data: sportsArray,
                selectedObjects: $selectedSport,
                maximumSelection: 1,
                lineCount: 1)
            // module to choose a performance's value
            SettingsSportValue(
                placeholder: "performances.settings.sportsInstructions".localized,
                unity: selectedSport.count == 1 ? selectedSport[0].unityInt16.sportUnityType : nil,
                pointsConversion: $value,
                caller: .performance,
                existingPointsConversion: selectedSport.count == 1 ? selectedSport[0].pointsConversion : nil)
            // module used to know if points have to be added to the common pot
            SettingsCustomToggleWithExplanations(
                title: "pots.title.maj".localized,
                question: "performances.settings.addPotQuestion".localized,
                isOn: $addToCommonPot,
                explanationsAreOn: "performances.settings.addExplanationsOn".localized,
                explanationsAreOff: "performances.settings.addExplanationsOff".localized,
                textLines: 2)
        }
        .inSettingsPage(
            "performances.new".localized,
            game: _game,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "performancesSettings"
        ) {
            guard selectedAthletics.count > 0, selectedSport.count == 1 else { return }
            game.addPerformance(sport: selectedSport[0], athletics: selectedAthletics, value: value, addToCommonPot: addToCommonPot)
        }
    }
    
}
