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
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        XCTAssert(game.pointsForOneEuro == 1000)
    }
    
    func testGivenAGameExistsWhenIndicateThatIntroductionHasBeenSeenThenGamesPropertyHasBeenChanged() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.introductionHasBeenSeen()
        XCTAssert(game.didSeeIntroduction)
    }
    
    func testGivenAGameExistsWhenAskForLoadingItThenGameIsLoaded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.introductionHasBeenSeen()
        let game2 = Game.initGame(coreDataStack: coreDataStack)
        XCTAssert(game2.didSeeIntroduction)
    }
    
    // MARK: - Athletics tests
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Ben")
    }
    
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
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
    }
    func testGivenAGameWithAthleticsExistsWhenAskToDeleteOneOfThemThenAthleticIsDeleted() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        game.deleteAthletic(game.athletics[0]) { result in
            switch result {
            case .success(let athletics):
                XCTAssert(athletics.count == 1)
                XCTAssert(athletics[0].name == "Elo")
            case . failure(_):
                XCTFail()
            }
        }
    }
    
    // MARK: - Sports tests
    
    func testGivenAGameExistsWhenAskToAddSportThenSportHasBeenAdded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addSport("Marche", to: game)
        XCTAssert(game.sports.count == 1)
        XCTAssert(game.sports[0].name == "Marche")
        XCTAssert(game.sports[0].unityType == .count)
    }
    
    func testGivenASportExistsWhenAskToAddASportWithTheSameNameThenErrorOccures() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addSport("Marche", to: game)
        game.addSport("Marche", unityType: .count, valueForOnePoint: 25) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .existingSport)
            }
        }
    }
    
    func testGivenSportsExistWhenAskToDeleteOneOfThemThenSportIsDeleted() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.deleteSport(game.sports[0]) { result in
            switch result {
            case .success(let sports):
                XCTAssert(sports.count == 1)
                XCTAssert(sports[0].name == "Rameur")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    // MARK: - Performances tests
    
    func testGivenAGameExistsWhenAskToAddPerformanceThenPerformanceHasBeenAdded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10])
        let pot = getPot(game: game)
        XCTAssert(pot.points == 10)
        XCTAssert(game.performances.count == 1)
    }
    
    func testGivenPerformancesExistWhenAskToDeleteOneOfThemThenPerformanceIsDeleted() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10])
        game.addPerformance(sport: game.sports[1], athletics: game.athletics, value: [100])
        game.deletePerformance(performance: game.performances[0])
        let pot = getPot(game: game)
        XCTAssert(pot.points == 10)
        XCTAssert(game.performances.count == 1)
    }
    
    // MARK: - Supporting methods
    
    func addAthletic(_ name: String, to game: Game) {
        game.addAthletic(name) { _ in
            return
        }
    }
    func addSport(_ name: String, to game: Game) {
        game.addSport(name, unityType: .count, valueForOnePoint: 1) { _ in
            return
        }
    }
    func getCoreDataStack() -> CoreDataStack {
        guard let coreDataStack = coreDataStack else {
            XCTFail()
            return FakeCoreDataStack()
        }
        return coreDataStack
    }
    func getPot(of owner: Athletic? = nil, game: Game) -> Pot {
        if let owner = owner {
            guard let pot = owner.pot else {
                XCTFail()
                return Pot()
            }
            return pot
        }
        guard let pot = game.commonPot else {
            XCTFail()
            return Pot()
        }
        return pot
    }
}
