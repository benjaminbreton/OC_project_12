//
//  PotCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct PotCell: View {
    //let pot: Pot?
    let pot: FakePot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? ""
        } else {
            return "Common pot"
        }
    }
    var body: some View {
        VStack() {
            HStack {
                Text(name)
                    .withTitleFont()
                Text("\(pot?.formattedAmount ?? "")")
                    .withTitleFont()
                    .layoutPriority(1)
            }
            
            Divider()
            HStack {
                GeometryReader { geometry in
                    Image(systemName: pot?.formattedEvolutionType.image.name ?? "arrow.forward.square")
                        .resizable()
                        //                    .scaledToFit()
                        .layoutPriority(0.5)
                        .frame(width: geometry.size.height, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(pot?.formattedEvolutionType.image.colorInt16.potEvolutionColor)
                }
                
                
                Text("expected: \(pot?.formattedAmount ?? "")")
                    .withSimpleFont()
                    .scaledToFill()
                    .layoutPriority(1)
            }
            
        }
        .padding()
        .inCellRectangle()
    }
}
