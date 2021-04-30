//
//  NavigationPotCell.swift
//  Carrots
//
//  Created by Benjamin Breton on 08/04/2021.
//

import SwiftUI
struct NavigationPotCell: View {
    let pot: FakePot?
    var name: String {
        if let athletic = pot?.owner {
            return athletic.name ?? ""
        } else {
            return "Common pot"
        }
    }
    var body: some View {
        PotCell(pot: pot)
            .withNavigationLink(destination: PotAddings(pot: pot))
    }
}
