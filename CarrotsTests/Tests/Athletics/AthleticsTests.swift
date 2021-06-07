//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class AthleticsTests: XCTestCase {
    
    var gameHandler: GameTestsHandler?
    var game: GameViewModel { gameHandler!.game }
    var support: CommonTestsSupport { gameHandler!.support }

    override func setUp() {
        self.gameHandler = GameTestsHandler()
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() throws {
        support.addAthletic("Ben")
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Ben")
        XCTAssert(game.athletics[0].description == "Ben")
    }
    func testGivenAthleticHasNoNameWhenAskHisNameThenNoNameIsGetted() throws {
        let athletic = support.addAthletic("Ben")
        athletic?.name = nil
        XCTAssert(athletic?.description == "all.noName".localized)
    }
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() throws {
        support.addAthletic("Ben")
        XCTAssertNil(game.error)
        support.addAthletic("Ben")
        let error = game.error
        XCTAssert(error?.description == ApplicationErrors.existingAthletic.description)
        XCTAssert(error?.userTitle == "error.existingAthletic.title".localized)
        XCTAssert(error?.userMessage == "error.existingAthletic.message".localized)
    }
    
    // MARK: - Modify
    
    func testGivenAthleticExistsWhenAskingToModifyHisNameThenHisNameIsModified() throws {
        guard let athletic = support.addAthletic(), game.error == nil else {
            XCTFail()
            return
        }
        game.modify(athletic, name: "Cheese", image: nil)
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Cheese")
    }
    
    // MARK: - Delete
    
    func testGivenAGameWithAthleticsExistsWhenAskToDeleteOneOfThemThenAthleticIsDeleted() throws {
        guard let athletic = support.addAthletic(), game.error == nil, game.athletics.count == 1 else {
            XCTFail()
            return
        }
        game.delete(athletic)
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 0)
    }

}
