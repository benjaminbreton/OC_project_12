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
    
    var gameDoor: GameDoor?
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        gameDoor = GameDoor(coreDataStack)
        gameDoor?.setFactorySettingsBack()
    }
    override func tearDown() {
        gameDoor = nil
    }
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.gameDoor)
        addSport("Walk")
        XCTAssertNil(game.error)
        XCTAssert(game.sports.count == 1)
        XCTAssert(game.sports[0].name == "Walk")
        XCTAssert(game.sports[0].unityType == .count)
    }
    func testGivenASportExistsWhenAskToAddASportWithTheSameNameThenErrorOccures() throws {
        let game = try XCTUnwrap(self.gameDoor)
        addSport("Walk")
        XCTAssertNil(game.error)
        addSport("Walk")
        XCTAssert(game.error?.description == ApplicationErrors.existingSport.description)
    }
    
    // MARK: - Modify
    
    func testGivenSportExistsWhenAskingToModifyItsNameAndTypeAndIconAndConversionThenItsModified() throws {
        let game = try XCTUnwrap(self.gameDoor)
        guard let sport = addSport(), game.error == nil else {
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
        let game = try XCTUnwrap(self.gameDoor)
        addSport()
        guard let sport = addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.delete(sport)
        XCTAssertNil(game.error)
        XCTAssert(game.sports.count == 1)
    }
    
    // MARK: - Supporting methods
    
    @discardableResult
    func addAthletic(_ name: String = UUID().uuidString) -> Athletic? {
        guard let game = gameDoor else { return nil }
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
        guard let game = gameDoor else { return nil }
        game.addSport(name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
        for sport in game.sports {
            if sport.name == name {
                return sport
            }
        }
        return nil
    }

}
