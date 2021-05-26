//
//  InSettingsModule.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import SwiftUI

// MARK: - ViewModifier

/**
 Will place the content in a page's module.
 */
fileprivate struct InModule: ViewModifier {
    
    // MARK: - Properties
    
    /// Module's title.
    private let title: String?
    /// Module's content's alignment.
    private let alignment: Alignment
    /// Module's explanations.
    private let explanations: String?
    /// Boolean indicating whether an error has been detected on module's changes, or not.
    private var isWrong: Binding<Bool>?
    /// Explanations to display if an error has been detected.
    private let wrongExplanations: String?
    
    // MARK: - Init
    
    init(title: String?, alignment: Alignment, explanations: String?, isWrong: Binding<Bool>? = nil, wrongExplanations: String?) {
        self.title = title
        self.alignment = alignment
        self.explanations = explanations
        self.isWrong = isWrong
        self.wrongExplanations = wrongExplanations
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        VStack {
            // If a title exists, display it
            if let title = title {
                Text(title)
                    .withTitleFont()
            }
            // Create module in a rectangle
            VStack {
                // If explanations exist, display them
                if let explanations = explanations {
                    Text(explanations)
                        .withLightSimpleFont()
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                // If an error has been detected, display explanations
                if let isWrong = isWrong {
                    if isWrong.wrappedValue, let explanations = wrongExplanations {
                        Text(explanations)
                            .withDeleteFont()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                // Display content
                content
            }
            .inRectangle(alignment)
            .withSimpleFont()
        }
    }
}

// MARK: - View's extension

extension View {
    /**
     Place the content in a page's module with a leading alignment.
     - parameter title: Module's title *(optional)*.
     - parameter explanations: Module's explanations *(optional)*.
     - parameter isWrong: Boolean indicating whether an error has been detected on module's changes, or not *(optional)*.
     - parameter wrongExplanations: Explanations to display if an error has been detected *(optional)*.
     */
    func inModule(_ title: String? = nil, explanations: String? = nil, isWrong: Binding<Bool>? = nil, wrongExplanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .leading, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations))
    }
    /**
     Place the content in a page's module with a centered alignment.
     - parameter title: Module's title *(optional)*.
     - parameter explanations: Module's explanations *(optional)*.
     - parameter isWrong: Boolean indicating whether an error has been detected on module's changes, or not *(optional)*.
     - parameter wrongExplanations: Explanations to display if an error has been detected *(optional)*.
     */
    func inCenteredModule(_ title: String? = nil, explanations: String? = nil, isWrong: Binding<Bool>? = nil, wrongExplanations: String? = nil) -> some View {
        modifier(InModule(title: title, alignment: .center, explanations: explanations, isWrong: isWrong, wrongExplanations: wrongExplanations))
    }
}
