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
    
    var game: GameViewModel?
    
    var support: CommonTestsSupport { CommonTestsSupport(game) }
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        game = GameViewModel(coreDataStack)
        game?.setFactorySettingsBack()
    }
    override func tearDown() {
        game = nil
    }
    
    // MARK: - Game Tests
    
    func testGivenNoGameHasBeenInitializedWhenCreateOneThenGameHasBeenSaved() throws {
        let game = try XCTUnwrap(self.game)
        XCTAssertNotNil(game.commonPot)
        XCTAssert(game.moneyConversion == "100")
    }
}
