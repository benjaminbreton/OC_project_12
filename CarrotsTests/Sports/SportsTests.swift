//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class SportsTests: XCTestCase {
    
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
    
    func testGivenAGameExistsWhenAskToAddSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk")
        XCTAssertNil(game.error)
        XCTAssert(game.sports.count == 1)
        XCTAssert(game.sports[0].name == "Walk")
        XCTAssert(game.sports[0].unityType == .count)
    }
    func testGivenASportExistsWhenAskToAddASportWithTheSameNameThenErrorOccures() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk")
        XCTAssertNil(game.error)
        support.addSport("Walk")
        XCTAssert(game.error?.description == ApplicationErrors.existingSport.description)
    }
    
    // MARK: - Modify
    
    func testGivenSportExistsWhenAskingToModifyItsNameAndTypeAndIconAndConversionThenItsModified() throws {
        let game = try XCTUnwrap(self.game)
        guard let sport = support.addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.modify(sport, name: "Cheese", icon: "C", unityType: .time, pointsConversion: ["1", "40", "30"])
        XCTAssertNil(game.error)
        XCTAssert(game.sports.count == 1)
        XCTAssert(game.sports[0].name == "Cheese")
        XCTAssert(game.sports[0].icon == "C")
        XCTAssert(game.sports[0].unityType == .time)
        XCTAssert(game.sports[0].pointsConversion == Sport.UnityType.time.value(for: ["1", "40", "30"]))
    }
    
    // MARK: - Delete
    
    func testGivenSportsExistWhenAskToDeleteOneOfThemThenSportIsDeleted() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport()
        guard let sport = support.addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.delete(sport)
        XCTAssertNil(game.error)
        XCTAssert(game.sports.count == 1)
    }

}
