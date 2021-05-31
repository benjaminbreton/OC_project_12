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
    
    // MARK: - Common pot
    
    func testGivenGameHasBeenCreatedWhenAskingCommonPotNameThenTheLocalizedNameIsGetted() throws {
        let game = try XCTUnwrap(self.game)
        XCTAssert(game.commonPot?.description == "pots.commonPot".localized)
    }
    
    // MARK: - Change amounts
    
    func testGivenPotContainsNothingWhenAskToAddMoneyThenMoneyHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        let athletic = support.addAthletic()
        game.changeMoney(amount: "10", operation: 0)
        game.changeMoney(for: athletic, amount: "50", operation: 0)
        XCTAssertNil(game.error)
        XCTAssert(game.commonPot?.amount == 10)
        XCTAssert(game.athletics[0].pot?.amount == 50)
    }
    
    func testGivenPotContainsSomeMoneyWhenAskToWithdrawSomeOfItThenMoneyHasBeenWithdrawn() throws {
        let game = try XCTUnwrap(self.game)
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
