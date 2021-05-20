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
    private var completeText: String { "help.\(text)".localized }
    var body: some View {
        Group {
            if hasToBeShown {
                Button(action: {
                    isShown.toggle()
                }, label: {
                    VStack {
                        HStack {
                            Image(systemName: "questionmark.diamond.fill")
                            Text("\(isShown ? "help.title".localized : "help.proposal".localized)")
                        }
                        if isShown {
                            CommonHeightSpacer()
                            Text(completeText)
                                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            CommonHeightSpacer()
                            Text("help.end".localized)
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
