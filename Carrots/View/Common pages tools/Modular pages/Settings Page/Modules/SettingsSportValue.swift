//
//  SportValue.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
/**
 Settings module used to set a value of a sport unity type.
 */
struct SettingsSportValue: View {
    
    // MARK: - Properties
    
    /// The choosen value.
    @Binding private var value: [String]
    /// The placeholder to display.
    private let placeholder: String
    /// The value's unity type.
    private var unity: Sport.UnityType? {
        didSet {
            value = ["", "", ""]
        }
    }
    /// The possible callers.
    enum Caller: Equatable { case sport, performance }
    /// The module's caller.
    private let caller: Caller
    /// The conversion from the value to points.
    private let pointsConversion: Int64
    
    // MARK: - Init
    
    init(placeholder: String, unity: Sport.UnityType?, pointsConversion: Binding<[String]>, caller: Caller, existingPointsConversion: Int64? = nil) {
        self.placeholder = placeholder
        self.unity = unity
        self._value = pointsConversion
        self.caller = caller
        self.pointsConversion = existingPointsConversion ?? 0
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // display value fields regarding the unity type and the caller
            if let sportUnity = unity {
                HStack {
                    switch sportUnity {
                    case .oneShot:
                        switch caller {
                        case .sport:
                            TextField(sportUnity.placeholders[0], text: $value[0])
                            Text(sportUnity.symbols[0])
                        case .performance:
                            Text("\("sportValue.oneShotGain".localized)\(pointsConversion) points.")
                                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        }
                    case .time:
                        TextField(sportUnity.placeholders[0], text: $value[0])
                        Text(sportUnity.symbols[0])
                        TextField(sportUnity.placeholders[1], text: $value[1])
                        Text(sportUnity.symbols[1])
                        TextField(sportUnity.placeholders[2], text: $value[2])
                        Text(sportUnity.symbols[2])
                    default:
                        TextField(sportUnity.placeholders[0], text: $value[0])
                        Text(sportUnity.symbols[0])
                    }
                }
            } else {
                Text(placeholder)
            }
        }
        .frame(height: ViewCommonSettings().textLineHeight)
        .keyboardType(.numberPad)
        .inCenteredModule(caller == .sport ? "sportValue.sportTitle".localized : "sportValue.performanceTitle".localized,
                  explanations: caller == .sport ? unity?.explanations : nil)
    }
}

