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
    @EnvironmentObject var gameDoor: GameDoor
    /// Choosen athletic.
    let athletic: Athletic
    /// Choosen athletic's image.
    private var image: UIImage? {
        guard let data = athletic.image else { return nil }
        return UIImage(data: data)
    }
    @State var rotation: Double = 0
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                AthleticImage(image: image, radius: ViewCommonSettings().commonHeight * 2, rotation: $rotation)
                Text(athletic.name ?? "No name")
                    .padding()
                    .withBigSimpleFont()
            }
        }
        .withNavigationLink(
            destination: AthleticDetails(athletic: athletic)
                .environmentObject(gameDoor)
        )
        .frame(height: ViewCommonSettings().commonHeight * 4)
        .inRectangle(.leading)
    }
}
