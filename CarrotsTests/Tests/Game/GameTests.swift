//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class GameTests: XCTestCase {
    
    var gameHandler: GameTestsHandler?
    var game: GameViewModel { gameHandler!.game }

    override func setUp() {
        self.gameHandler = GameTestsHandler()
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    // MARK: - Game Tests
    
    func testGivenNoGameHasBeenInitializedWhenCreateOneThenGameHasBeenSaved() throws {
        XCTAssertNotNil(game.commonPot)
        XCTAssert(game.moneyConversion == "100")
    }
}
