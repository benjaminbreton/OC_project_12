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
    
    // MARK: - Modify
    
    func testGivenGameExistsWhenAskingToModifySettingsThenSettingsAreModified() throws {
        let game = try XCTUnwrap(self.game)
        let date = Date() + 60 * 24 * 3600
        game.modifySettings(predictionDate: date, moneyConversion: "500", showHelp: false)
        XCTAssertNil(game.error)
        print(game.predictionDate)
        XCTAssert(game.predictionDate == date)
        XCTAssert(game.moneyConversion == "500")
        XCTAssert(!game.showHelp)
    }
    func testGivenWarningHasntBeenAcceptedWhenDidAcceptItThenItsAccepted() throws {
        let game = try XCTUnwrap(self.game)
        XCTAssert(!game.didValidateWarning)
        game.validateWarning()
        XCTAssertNil(game.error)
        XCTAssert(game.didValidateWarning)
    }
    
    func testGivenPredictionDateIsOlderThanTodayWhenGameIsCreatedThenDateIsChanged() throws {
        let game = try XCTUnwrap(self.game)
        game.modifySettings(predictionDate: Date().yesterday, moneyConversion: game.moneyConversion, showHelp: game.showHelp)
        XCTAssertNil(game.error)
        self.game = nil
        let coreDataStack = FakeCoreDataStack()
        self.game = GameViewModel(coreDataStack)
        let game2 = try XCTUnwrap(self.game)
        XCTAssert(game2.predictionDate == Date().today + 30 * 24 * 3600)
    }

}
