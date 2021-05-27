//
//  HelpView.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/05/2021.
//

import Foundation
import SwiftUI
/**
 View used to display a help frame.
 */
struct HelpView: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Boolean indicating whether the help text is shown or not.
    @Binding var isShown: Bool
    /// Help's text's name.
    private let text: String
    /// Boolean indicating whether help has been enabled in the app's settings or not.
    private var hasToBeShown: Bool { game.showHelp }
    /// Help's text getted with its name.
    private var completeText: String { "help.\(text)".localized }
    
    // MARK: - Init
    
    init(text: String, isShown: Binding<Bool>) {
        self.text = text
        self._isShown = isShown
    }
    
    // MARK: - Body
    
    var body: some View {
        // add something in the group if help is enabled
        if hasToBeShown {
            Button(action: {
                // when help's frame is hitten, toggle the text visibility
                isShown.toggle()
            }, label: {
                // help's frame
                VStack {
                    // title
                    HStack {
                        Image(systemName: "questionmark.diamond.fill")
                        Text("\(isShown ? "help.title".localized : "help.proposal".localized)")
                    }
                    // text if it has to be shown
                    if isShown {
                        VerticalSpacer()
                        Text(completeText)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        VerticalSpacer()
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
