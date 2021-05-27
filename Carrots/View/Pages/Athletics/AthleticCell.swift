//
//  AthleticCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
/**
 The cell to display in an athletics list.
 */
struct AthleticCell: View {
    
    // MARK: - Properties
    
    /// The ViewModel.
    @EnvironmentObject private var game: GameViewModel
    /// Choosen athletic.
    private let athletic: Athletic
    /// Choosen athletic's image.
    private var image: UIImage? {
        guard let data = athletic.image else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Init
    
    init(_ athletic: Athletic) {
        self.athletic = athletic
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                // image
                AthleticImage(image: image, radius: ViewCommonSettings().commonSizeBase * 2)
                // name
                Text(athletic.description)
                    .padding()
                    .withBigSimpleFont()
            }
        }
        .inRectangle(.leading)
        .inNavigationLink(
            AthleticDetails(athletic: athletic)
        )
    }
}
