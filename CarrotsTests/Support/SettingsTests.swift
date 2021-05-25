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
    
    var gameDoor: GameDoor?
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        gameDoor = GameDoor(coreDataStack)
        gameDoor?.setFactorySettingsBack()
    }
    override func tearDown() {
        gameDoor = nil
    }
    
    // MARK: - Modify
    
    func testGivenGameExistsWhenAskingToModifySettingsThenSettingsAreModified() throws {
        let game = try XCTUnwrap(self.gameDoor)
        let date = Date() + 60 * 24 * 3600
        game.modifySettings(predictionDate: date, moneyConversion: "500", showHelp: false)
        XCTAssertNil(game.error)
        XCTAssert(game.predictionDate == date)
        XCTAssert(game.moneyConversion == "500")
        XCTAssert(!game.showHelp)
    }
    func testGivenWarningHasntBeenAcceptedWhenDidAcceptItThenItsAccepted() throws {
        let game = try XCTUnwrap(self.gameDoor)
        XCTAssert(!game.didValidateWarning)
        game.validateWarning()
        XCTAssertNil(game.error)
        XCTAssert(game.didValidateWarning)
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
