//
//  SportValue.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct SportValue: View {
    let placeholder: String
    let unity: Sport.UnityType?
    @Binding var value: [String]
    var body: some View {
        return VStack {
            Text("Value")
                .withTitleFont()
            ZStack {
                if let sportUnity = unity {
                    HStack {
                        switch sportUnity {
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
            .frame(height: ViewCommonSettings().lineHeight)
            .withSimpleFont()
            .keyboardType(.numberPad)
            .inRectangle(.center)
        }
    }
}

