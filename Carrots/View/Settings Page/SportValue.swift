//
//  SportValue.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/04/2021.
//

import SwiftUI
struct SportValue: View {
    @Binding var sport: [FakeSport]
    @Binding var value: [String]
    var body: some View {
        VStack {
            Text("Value")
                .withTitleFont()
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: ViewCommonSettings().commonCornerRadius)
                    .foregroundColor(.backCell)
                    .opacity(ViewCommonSettings().commonOpacity)
                if sport.count == 1 {
                    HStack {
                        switch sport[0].unityInt16.sportUnityType {
                        case .time:
                            TextField("hours", text: $value[0])
                            Text(" h ")
                            TextField("min.", text: $value[1])
                            Text(" m ")
                            TextField("sec.", text: $value[2])
                            Text(" s ")
                        case .kilometers:
                            TextField("distance", text: $value[0])
                            Text(" km")
                        case .count:
                            TextField("count", text: $value[0])
                        }
                    }
                    .withSimpleFont()
                    .keyboardType(.numberPad)
                } else {
                    Text("Choose a sport")
                        .withSimpleFont()
                }
            }
            .frame(height: ViewCommonSettings().lineHeight)
        }
    }
}
