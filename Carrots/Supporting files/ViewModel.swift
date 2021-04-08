//
//  ViewModel.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/03/2021.
//

import Foundation
class ViewModel: ObservableObject {
    @Published var game = Game()
    func addAthletic(_ name: String) {
        game.addAthletic(name)
    }
}
