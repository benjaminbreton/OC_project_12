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
        XCTAssert(game.sports[0].performances.count == 0)
        XCTAssert(game.sports[0].name == "Walk")
        XCTAssert(game.sports[0].name == game.sports[0].description)
    }
    func testGivenASportExistsWhenAskToAddASportWithTheSameNameThenErrorOccures() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk")
        XCTAssertNil(game.error)
        support.addSport("Walk")
        XCTAssert(game.error?.description == ApplicationErrors.existingSport.description)
    }
    func testGivenSportHasNoNameWhenAskItsNameThenNoNameIsGetted() throws {
        let sport = support.addSport()
        sport?.name = nil
        XCTAssert(sport?.description == "all.noName".localized)
    }
    
    // MARK: - Unity types
    
    func testGivenAGameExistsWhenAskToAddCountSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk")
        XCTAssertNil(game.error)
        XCTAssert(game.sports[0].unityType == .count)
        XCTAssert(game.sports[0].pointsConversion == 100)
        XCTAssert(game.sports[0].pointsConversionSingleString == "100")
        XCTAssert(game.sports[0].pointsConversionStringArray == ["100", "0", "0"])
        XCTAssert(game.sports[0].unityType.description == "sports.unityType.count.description".localized)
        XCTAssert(game.sports[0].unityType.explanations == "sports.unityType.count.explanations".localized)
        XCTAssert(game.sports[0].unityType.placeholders == ["sports.unityType.count.placeholder1".localized])
        XCTAssert(game.sports[0].pointsToAdd(for: 100) == 1)
    }
    
    func testGivenAGameExistsWhenAskToAddTimeSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk", icon: "A", unityType: .time, pointsConversion: ["1", "5", "0"])
        XCTAssertNil(game.error)
        XCTAssert(game.sports[0].unityType == .time)
        XCTAssert(game.sports[0].pointsConversion == 3900)
        XCTAssert(game.sports[0].pointsConversionSingleString == "1 h 05 m ")
        XCTAssert(game.sports[0].pointsConversionStringArray == ["1", "5", "0"])
        XCTAssert(game.sports[0].unityType.description == "sports.unityType.time.description".localized)
        XCTAssert(game.sports[0].unityType.explanations == "sports.unityType.time.explanations".localized)
        XCTAssert(game.sports[0].unityType.placeholders == ["sports.unityType.time.placeholder1".localized, "sports.unityType.time.placeholder2".localized, "sports.unityType.time.placeholder3".localized])
        XCTAssert(game.sports[0].pointsToAdd(for: 3900) == 1)
    }
    
    func testGivenAGameExistsWhenAskToAddDistanceSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk", icon: "A", unityType: .distance, pointsConversion: ["1000", "", ""])
        XCTAssertNil(game.error)
        XCTAssert(game.sports[0].unityType == .distance)
        XCTAssert(game.sports[0].pointsConversion == 1000)
        XCTAssert(game.sports[0].pointsConversionSingleString == "1000 m")
        XCTAssert(game.sports[0].pointsConversionStringArray == ["1000", "0", "0"])
        XCTAssert(game.sports[0].unityType.description == "sports.unityType.distance.description".localized)
        XCTAssert(game.sports[0].unityType.explanations == "sports.unityType.distance.explanations".localized)
        XCTAssert(game.sports[0].unityType.placeholders == ["sports.unityType.distance.placeholder1".localized])
        XCTAssert(game.sports[0].pointsToAdd(for: 1000) == 1)
    }
    
    func testGivenAGameExistsWhenAskToAddoneShotSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        support.addSport("Walk", icon: "A", unityType: .oneShot, pointsConversion: ["100", "", ""])
        XCTAssertNil(game.error)
        XCTAssert(game.sports[0].unityType == .oneShot)
        XCTAssert(game.sports[0].pointsConversion == 100)
        XCTAssert(game.sports[0].pointsConversionSingleString == "100 pts")
        XCTAssert(game.sports[0].pointsConversionStringArray == ["100", "0", "0"])
        XCTAssert(game.sports[0].unityType.description == "sports.unityType.oneShot.description".localized)
        XCTAssert(game.sports[0].unityType.explanations == "sports.unityType.oneShot.explanations".localized)
        XCTAssert(game.sports[0].unityType.placeholders == ["sports.unityType.oneShot.placeholder1".localized])
        XCTAssert(game.sports[0].pointsToAdd(for: 0) == 100)
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
