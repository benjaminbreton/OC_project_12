//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class CommonTestsSupport {
    
    var game: GameViewModel?
    
    
    init(_ game: GameViewModel?) {
        self.game = game
    }
    
    // MARK: - Supporting methods
    
    @discardableResult
    func addAthletic(_ name: String = UUID().uuidString) -> Athletic? {
        guard let game = game else { return nil }
        game.addAthletic(name: name, image: nil)
        for athletic in game.athletics {
            if athletic.name == name {
                return athletic
            }
        }
        return nil
    }
    
    @discardableResult
    func addSport(_ name: String = UUID().uuidString, icon: String = "A", unityType: Sport.UnityType = .count, pointsConversion: [String?] = ["100", "0", "0"]) -> Sport? {
        guard let game = game else { return nil }
        game.addSport(name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
        for sport in game.sports {
            if sport.name == name {
                return sport
            }
        }
        return nil
    }
}

class GameHandler {
    
    var coreDataStack: FakeCoreDataStack
    var game: GameViewModel
    var support: CommonTestsSupport { CommonTestsSupport(game) }
    
    init(_ today: Date = Date().today) {
        coreDataStack = FakeCoreDataStack()
        game = GameViewModel(coreDataStack, today: today, setFactorySettingsBack: true)
    }
    
    func reloadGame(for today: Date = Date().today) {
        game = GameViewModel(coreDataStack, today: today, setFactorySettingsBack: false)
    }
}
