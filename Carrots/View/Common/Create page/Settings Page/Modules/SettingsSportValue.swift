//
//  SportValue.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct SettingsSportValue: View {
    let placeholder: String
    var unity: Sport.UnityType? {
        didSet {
            value = ["", "", ""]
        }
    }
    @Binding var value: [String]
    enum Caller: Equatable { case sport, performance }
    let caller: Caller
    let valueForOnePoint: Int64
    
    init(placeholder: String, unity: Sport.UnityType?, valueForOnePoint: Binding<[String]>, caller: Caller, existingValueForOnePoint: Int64? = nil) {
        self.placeholder = placeholder
        self.unity = unity
        self._value = valueForOnePoint
        self.caller = caller
        self.valueForOnePoint = existingValueForOnePoint ?? 0
    }
    
    var body: some View {
        ZStack {
            if let sportUnity = unity {
                HStack {
                    switch sportUnity {
                    case .oneShot:
                        switch caller {
                        case .sport:
                            TextField(sportUnity.placeholders[0], text: $value[0])
                            Text(sportUnity.symbols[0])
                        case .performance:
                            Text("By doing this sport, you'll earn \(valueForOnePoint) points.")
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
        .inModule(caller == .sport ? "Needs to get 1 point" : "Performance", explanations: caller == .sport ? unity?.explanations : nil)
    }
}

