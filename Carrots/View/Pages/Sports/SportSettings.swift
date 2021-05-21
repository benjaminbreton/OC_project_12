//
//  SportSettings.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct SportSettings: View {
    @EnvironmentObject var gameDoor: GameDoor
    let sport: Sport?
    @State var name: String
    @State var icon: String
    @State var unity: [Sport.UnityType]
    @State var valueForOnePoint: [String]
    @State var isNameEmpty: Bool = false
    var confirmationButtonIsDisabled: Bool {
        isNameEmpty ||
            unity.count == 0 ||
            (unity[0] != .time && Int(valueForOnePoint[0]) ?? 0 == 0) ||
            (unity[0] == .time && valueForOnePoint.map({ Int($0) ?? 0 }).reduce(0, +) == 0)
    }
    private let unities: [Sport.UnityType] = [.count, .distance, .time, .oneShot]
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
    var body: some View {
        VStack {
            SettingsTextfield(
                title: "all.name".localized,
                placeHolder: "all.name".localized,
                value: $name,
                keyboard: .default,
                isWrong: $isNameEmpty,
                limits: (minCount: 1, maxCount: nil), limitsExplanations: (minCount: "sports.settings.limitName".localized, maxCount: nil))
            SettingsCustomPicker(
                titleOne: "sports.details.unityTitle".localized,
                titleMany: "sports.details.unityTitle".localized,
                data: unities,
                selectedObjects: $unity,
                maximumSelection: 1,
                lineCount: 1)
            SettingsSportValue(
                placeholder: "sports.settings.valuePlaceholder".localized,
                unity: unity.count == 1 ? unity[0] : nil,
                valueForOnePoint: $valueForOnePoint,
                caller: .sport)
            SettingsSportIconPicker(icon: $icon)
        }
        .inSettingsPage(
            name == "" ? "sports.settings.new".localized:"\(name)",
            gameDoor: _gameDoor,
            confirmationButtonIsDisabled: confirmationButtonIsDisabled,
            helpText: "sportsSettings") {
            guard unity.count == 1 else { return }
            if let sport = sport {
                gameDoor.update(sport, name: name, icon: icon, unityType: unity[0].int16, valueForOnePoint: valueForOnePoint)
            } else {
                gameDoor.addSport(name: name, icon: icon, unityType: unity[0].int16, valueForOnePoint: valueForOnePoint)
            }
        }
    }
}
