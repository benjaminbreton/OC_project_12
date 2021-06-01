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
        XCTAssert(game.athletics[0].description == "Ben")
    }
    func testGivenAthleticHasNoNameWhenAskHisNameThenNoNameIsGetted() throws {
        let athletic = support.addAthletic("Ben")
        athletic?.name = nil
        XCTAssert(athletic?.description == "all.noName".localized)
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
    
    // MARK: - Evolution
    
    func testGivenAGameHasBeenCreated45daysAgoWhenAddingPerformancesThenEvolutionsAreOk() throws {
        let coreDataStack = FakeCoreDataStack()
        
        // day - 45 : create athletic and sport
        
        self.game = GameViewModel(coreDataStack, today: Date().today - 45 * 24 * 3600)
        let athletic = try XCTUnwrap(support.addAthletic())
        XCTAssertNil(game?.error)
        let sport = try XCTUnwrap(support.addSport())
        XCTAssertNil(game?.error)
        // the athletic has just been created, so his evolution has the "same" value
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "yellow")
        // reload game on day - 45 to test the evolutiondatas count
        self.game = GameViewModel(coreDataStack, today: Date().today - 45 * 24 * 3600)
        XCTAssert(game?.athletics[0].evolutionDatas.count == 1)
        
        // day - 31 : add performance
        
        self.game = GameViewModel(coreDataStack, today: Date().today - 31 * 24 * 3600)
        // no performance has been made on day - 45, so the evolution is same
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "yellow")
        // add performance
        game?.addPerformance(sport: sport, athletics: [athletic], value: ["10000", "", ""], addToCommonPot: false, date: Date().now - 31 * 24 * 3600)
        XCTAssertNil(game?.error)
        
        // day - 29 : add performance
        
        self.game = GameViewModel(coreDataStack, today: Date().today - 29 * 24 * 3600)
        // a performance has been made on day - 31, so the evolution is up
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.up.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "lightGreen")
        // add performance
        game?.addPerformance(sport: sport, athletics: [athletic], value: ["5000", "", ""], addToCommonPot: true, date: Date().now - 29 * 24 * 3600)
        XCTAssertNil(game?.error)
        
        // day D : check conditions of success
        
        self.game = GameViewModel(coreDataStack)
        XCTAssert(game?.athletics.count == 1)
        XCTAssert(game?.performances.count == 2)
        // points = 10000 / 100 = 100
        XCTAssert(athletic.pot?.points == 100)
        // 100 points = 1 $
        XCTAssert(athletic.pot?.formattedAmount == "$US 1.00")
        // 100 points for 1080h = 0,09pts/h approx. Prediction for 30 days = amount (1$) + 0,09 * 30 * 24 = 1.67 approx.
        XCTAssert(athletic.pot?.formattedPredictionAmount == "$US 1.67")
        // a performance has been made on day - 29, but only for the common pot. The athletic's pot's evolution is down, the common pot's is up.
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.down.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "red")
        XCTAssert(game?.commonPot?.evolution.image.name == "arrow.up.right.square")
        XCTAssert(game?.commonPot?.evolution.image.color == "lightGreen")
        // There are 3 evolutiondatas : today, today-29, and today-31 to have an evolution on 30 days. Today-31 is essential because there's no evolution for today-30. Today-45 has to be deleted.
        XCTAssert(athletic.evolutionDatas.count == 3)
        XCTAssert(game?.commonPot?.evolutionDatas.count == 3)
        XCTAssert(athletic.pot?.evolutionDatas.count == 3)
        // The first evolution has to be Today-31.
        XCTAssert(athletic.evolutionDatas[0].date == Date().today - 31 * 24 * 3600)
    }

}
