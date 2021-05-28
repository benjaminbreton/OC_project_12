//
//  SportCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 The cell to display in a sports list.
 */
struct SportCell: View {
    
    
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// The sport.
    private let sport: Sport
    
    // MARK: - Init
    
    init(_ sport: Sport) {
        self.sport = sport
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center) {
            // icon
            SportIcon(icon: sport.icon ?? "", lineCount: 2)
            HorizontalSpacer()
            VStack(alignment: .leading) {
                // name
                Text(sport.description)
                    .withBigSimpleFont()
                // unity type
                Text("\(sport.unityType.description)")
                    .withSimpleFont()
            }
        }
        .inRectangle(.leading)
        .inNavigationLink(
            SportDetails(sport: sport)
        )
        
    }
}
