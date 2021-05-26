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
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addAthletic("Ben")
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Ben")
    }
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() throws {
        let game = try XCTUnwrap(self.game)
        support.addAthletic("Ben")
        XCTAssertNil(game.error)
        support.addAthletic("Ben")
        XCTAssert(game.error?.description == ApplicationErrors.existingAthletic.description)
    }
    
    // MARK: - Modify
    
    func testGivenAthleticExistsWhenAskingToModifyHisNameThenHisNameIsModified() throws {
        let game = try XCTUnwrap(self.game)
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
        let game = try XCTUnwrap(self.game)
        guard let athletic = support.addAthletic(), game.error == nil, game.athletics.count == 1 else {
            XCTFail()
            return
        }
        game.delete(athletic)
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 0)
    }

}
