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
    
    // MARK: - Game Tests
    
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
    
    // MARK: - Athletics tests
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.addAthletic("Ben") { result in
            switch result {
            case .success(let athleticsArray):
                XCTAssert(athleticsArray.count == 1)
                XCTAssert(athleticsArray[0].name == "Ben")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return
        }
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.addAthletic("Ben") { result in
            switch result {
            case .success(_):
                game.addAthletic("Ben") { result in
                    switch result {
                    case .success(_):
                        XCTFail()
                    case .failure(let error):
                        print(error)
                        print(error.userDescription)
                        XCTAssert(error == .existingAthletic)
                    }
                }
            case .failure(_):
                XCTFail()
            }
        }
    }
    

}
