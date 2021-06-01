//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class SettingsTests: XCTestCase {
    
    var gameHandler: GameTestsHandler?
    var game: GameViewModel { gameHandler!.game }
    var support: CommonTestsSupport { gameHandler!.support }
    
    override func setUp() {
        self.gameHandler = GameTestsHandler()
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    // MARK: - Modify
    
    func testGivenGameExistsWhenAskingToModifySettingsThenSettingsAreModified() throws {
        let date = Date() + 60 * 24 * 3600
        game.modifySettings(predictionDate: date, moneyConversion: "500", showHelp: false)
        XCTAssertNil(game.error)
        print(game.predictionDate)
        XCTAssert(game.predictionDate == date)
        XCTAssert(game.moneyConversion == "500")
        XCTAssert(!game.showHelp)
    }
    func testGivenWarningHasntBeenAcceptedWhenDidAcceptItThenItsAccepted() throws {
        XCTAssert(!game.didValidateWarning)
        game.validateWarning()
        XCTAssertNil(game.error)
        XCTAssert(game.didValidateWarning)
    }
    
    func testGivenPredictionDateIsOlderThanTodayWhenGameIsCreatedThenDateIsChanged() throws {
        game.modifySettings(predictionDate: Date().yesterday, moneyConversion: game.moneyConversion, showHelp: game.showHelp)
        XCTAssertNil(game.error)
        gameHandler?.reloadGame()
        XCTAssert(game.predictionDate == Date().today + 30 * 24 * 3600)
    }

}
