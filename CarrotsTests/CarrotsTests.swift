//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
@testable import Carrots

class CarrotsTests: XCTestCase {

    var coreDataStack: CoreDataStack?
    
    override func setUp() {
        coreDataStack = FakeCoreDataStack()
    }
    override func tearDown() {
        coreDataStack = nil
    }
    
    // MARK: - Tests
    
    func testGivenNoGameHasBeenInitializedWhenCreateOneThenGameHasBeenSaved() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        XCTAssert(game.pointsForOneEuro == 1000)
    }
    
    func testGivenAGameExistsWhenIndicateThatIntroductionHasBeenSeenThenGamesPropertyHasBeenChanged() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.introductionHasBeenSeen()
        XCTAssert(game.didSeeIntroduction)
    }
    
    func testGivenAGameExistsWhenAskForLoadingItThenGameIsLoaded() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.introductionHasBeenSeen()
        let game2 = Game.initGame(coreDataStack: coreDataStack)
        XCTAssert(game2.didSeeIntroduction)
    }
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.addAthletic("Ben")
        guard let athletics = game.athletics?.allObjects as? [Athletic] else {
            XCTFail()
            return
        }
        XCTAssert(athletics.count == 1)
        XCTAssert(athletics[0].name == "Ben")
    }
    

}
