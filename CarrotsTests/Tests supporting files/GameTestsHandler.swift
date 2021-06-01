//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class GameTestsHandler {
    
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
