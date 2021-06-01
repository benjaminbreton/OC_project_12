//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class PotsTests: XCTestCase {
    
    var gameHandler: GameTestsHandler?
    var game: GameViewModel { gameHandler!.game }
    var support: CommonTestsSupport { gameHandler!.support }
    var coreDataStack: FakeCoreDataStack { gameHandler!.coreDataStack }
    
    override func setUp() {
        self.gameHandler = GameTestsHandler()
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    // MARK: - Common pot
    
    func testGivenGameHasBeenCreatedWhenAskingCommonPotNameThenTheLocalizedNameIsGetted() throws {
        XCTAssert(game.commonPot?.description == "pots.commonPot".localized)
        XCTAssert(game.commonPot?.isFirstDay == true)
    }
    func testGivenACommonPotExistsWhenAddAnOtherCommonPotAndReloadGameThenTheSecondCommonPotIsDeleted() throws {
        // check common pot
        XCTAssert(game.commonPot?.points == 0)
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 1)
        // add common pot
        addCommonPot()
        // check common pots
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 2)
        // reload
        gameHandler?.reloadGame()
        // check common pot
        XCTAssert(game.commonPot?.points == 0)
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 1)
        // add performance
        guard let athletic = support.addAthletic(), let sport = support.addSport() else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic], value: ["100", "0", "0"], addToCommonPot: true)
        // check common pot
        XCTAssert(game.commonPot?.points == 1)
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 1)
        // add common pot
        addCommonPot()
        // check common pots
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 2)
        // reload
        gameHandler?.reloadGame()
        // check common pot
        XCTAssert(game.commonPot?.points == 1)
        XCTAssert(coreDataStack.entities.allPots.map({ $0.owner == nil ? 1 : 0 }).reduce(0, +) == 1)
    }
    
    private func addCommonPot() {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.points = 0
        let commonPot = CommonPot(context: coreDataStack.viewContext)
        commonPot.pot = pot
        coreDataStack.saveContext()
    }
    
    func testGivenCommonPotHasBeenDeletedWhenReloadGameThenErrorIsDisplayedOnTheConsoleAndCommonPotReturnsNil() throws {
        let commonPot = try XCTUnwrap(game.commonPot?.commonPotParent)
        coreDataStack.viewContext.delete(commonPot)
        coreDataStack.saveContext()
        gameHandler?.reloadGame()
        XCTAssertNil(game.commonPot)
    }
    
    // MARK: - Change amounts
    
    func testGivenPotContainsNothingWhenAskToAddMoneyThenMoneyHasBeenAdded() throws {
        let athletic = support.addAthletic()
        game.changeMoney(amount: "10", operation: 0)
        game.changeMoney(for: athletic, amount: "50", operation: 0)
        XCTAssertNil(game.error)
        XCTAssert(game.commonPot?.amount == 10)
        XCTAssert(game.athletics[0].pot?.amount == 50)
    }
    
    func testGivenPotContainsSomeMoneyWhenAskToWithdrawSomeOfItThenMoneyHasBeenWithdrawn() throws {
        let athletic = support.addAthletic()
        game.changeMoney(amount: "100", operation: 0)
        game.changeMoney(for: athletic, amount: "50", operation: 0)
        game.changeMoney(amount: "10", operation: 1)
        game.changeMoney(for: athletic, amount: "5", operation: 1)
        XCTAssertNil(game.error)
        XCTAssert(game.commonPot?.amount == 90)
        XCTAssert(game.athletics[0].pot?.amount == 45)
    }

}

/*
 
 */
