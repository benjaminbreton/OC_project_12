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
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() throws {
        let game = try XCTUnwrap(self.gameDoor)
        addAthletic("Ben")
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Ben")
    }
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() throws {
        let game = try XCTUnwrap(self.gameDoor)
        addAthletic("Ben")
        XCTAssertNil(game.error)
        addAthletic("Ben")
        XCTAssert(game.error?.description == ApplicationErrors.existingAthletic.description)
    }
    
    // MARK: - Modify
    
    func testGivenAthleticExistsWhenAskingToModifyHisNameThenHisNameIsModified() throws {
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic = addAthletic(), game.error == nil else {
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
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic = addAthletic(), game.error == nil, game.athletics.count == 1 else {
            XCTFail()
            return
        }
        game.delete(athletic)
        XCTAssertNil(game.error)
        XCTAssert(game.athletics.count == 0)
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
