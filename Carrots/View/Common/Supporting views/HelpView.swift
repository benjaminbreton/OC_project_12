//
//  HelpView.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/05/2021.
//

import Foundation
import SwiftUI
struct HelpView: View {
    let text: String
    @Binding var isShown: Bool
    var hasToBeShown: Bool
    var body: some View {
        Group {
            if hasToBeShown {
                Button(action: {
                    isShown.toggle()
                }, label: {
                    VStack {
                        HStack {
                            Image(systemName: "questionmark.diamond.fill")
                            Text("\(isShown ? "Help :" : "Need some help ? click here")")
                        }
                        if isShown {
                            CommonHeightSpacer()
                            Text(text)
                                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            CommonHeightSpacer()
                            Text("Click here again to close this help.")
                        }
                    }
                    .inRectangle(.leading)
                    .withLightSimpleFont()
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                })
            }
        }
        
    }
}
