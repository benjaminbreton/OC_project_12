//
//  AthleticCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 09/04/2021.
//

import SwiftUI
struct AthleticCell: View {
    
    // MARK: - Properties
    
    /// Viewmodel.
    @EnvironmentObject var game: GameViewModel
    /// Choosen athletic.
    let athletic: Athletic
    /// Choosen athletic's image.
    private var image: UIImage? {
        guard let data = athletic.image else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                
                AthleticImage(image: image, radius: ViewCommonSettings().commonSizeBase * 2)
                Text(athletic.name ?? "all.noName".localized)
                    .padding()
                    .withBigSimpleFont()
            }
            
        }
        .frame(height: ViewCommonSettings().commonSizeBase * 4)
        .inRectangle(.leading)
        .withNavigationLink(
            destination: AthleticDetails(athletic: athletic)
        )
        
    }
}
