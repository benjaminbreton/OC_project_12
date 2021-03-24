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
    
    // MARK: - Pot tests
    
    func testGivenPotContainsNothingWhenAskToAddMoneyThenMoneyHasBeenAdded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        let pot = getPot(game: game)
        let athleticPot = getPot(of: game.athletics[0], game: game)
        game.addMoney(to: game, amount: 10)
        game.addMoney(to: game.athletics[0], amount: 50)
        XCTAssert(pot.amount == 10)
        XCTAssert(athleticPot.amount == 50)
    }
    
    func testGivenPotContainsSomeMoneyWhenAskToWithdrawSomeOfItThenMoneyHasBeenWithdrawn() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        game.addMoney(to: game, amount: 100)
        game.withdrawMoney(to: game, amount: 30)
        addAthletic("Ben", to: game)
        game.addMoney(to: game.athletics[0], amount: 200)
        game.withdrawMoney(to: game.athletics[0], amount: 195)
        let pot = getPot(game: game)
        let athleticPot = getPot(of: game.athletics[0], game: game)
        XCTAssert(pot.amount == 70)
        XCTAssert(athleticPot.amount == 5)
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
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { result in
            switch result {
            case .success(_):
                let pot = getPot(game: game)
                XCTAssert(pot.points == 10)
                XCTAssert(game.performances.count == 1)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithoutAthleticThenErrorOccures() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: [], value: [10], addToCommonPot: true) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .performanceWithoutAthletic)
            }
        }
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithPointsInTheCommonAndIndividualPotsThenPerformanceHasBeenAdded() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: false) { _ in }
        let pot = getPot(game: game)
        let athletic1Pot = getPot(of: game.athletics[0], game: game)
        let athletic2Pot = getPot(of: game.athletics[1], game: game)
        XCTAssert(pot.points == 20)
        XCTAssert(athletic1Pot.points == 10)
        XCTAssert(athletic2Pot.points == 10)
        XCTAssert(game.performances.count == 2)
    }
    
    
    
    func testGivenPerformancesExistWhenAskToDeleteOneOfThemThenPerformanceIsDeleted() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[1], athletics: game.athletics, value: [100], addToCommonPot: true) { _ in }
        game.deletePerformance(game.performances[0])
        let pot = getPot(game: game)
        XCTAssert(pot.points == 10)
        XCTAssert(game.performances.count == 1)
    }
    
    func testGivenPerformancesExistWhenAskToDeleteAllOfThemThenPerformancesAreDeleted() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[1], athletics: game.athletics, value: [100], addToCommonPot: false) { _ in }
        game.deletePerformance(game.performances[0])
        game.deletePerformance(game.performances[0])
        let pot = getPot(game: game)
        let athletic1Pot = getPot(of: game.athletics[0], game: game)
        let athletic2Pot = getPot(of: game.athletics[1], game: game)
        XCTAssert(pot.points == 0)
        XCTAssert(athletic1Pot.points == 0)
        XCTAssert(athletic2Pot.points == 0)
        XCTAssert(game.performances.count == 0)
    }
    
    // MARK: - Several tests
    
    func testGivenPerformancesExistsWhenAthleticSportAndPerformancesHasBeenDeletedThenTheyAreSuccessfullyDeletedAndPointsTotalIsCorrect() {
        let coreDataStack = getCoreDataStack()
        let game = Game.initGame(coreDataStack: coreDataStack)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        let athletic1 = game.athletics[0]
        let athletic2 = game.athletics[1]
        addSport("Marche", to: game)
        let sport = game.sports[0]
        let pot = getPot(game: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [15], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [30], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [100], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: [athletic1], value: [50], addToCommonPot: true) { _ in }
        game.deleteAthletic(athletic1) { result in
            switch result {
            case .success(_):
                game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [70], addToCommonPot: true) { _ in }
                game.deletePerformance(game.performances[2])
                game.deleteSport(sport) { result in
                    switch result {
                    case .success(_):
                        XCTAssert(game.performances.count == 0)
                        XCTAssert(game.athletics.count == 1)
                        XCTAssert(game.athletics == [athletic2])
                        /*
                         points calculation :
                         > pot at the beginning : 0
                         - performance 1, 2 athletics, so :  15 x 2 = +  30pts
                         > total : 30
                         - performance 2, 2 athletics, so :  30 x 2 = +  60pts
                         > total : 90
                         - performance 3, 2 athletics, so : 100 x 2 = + 200pts
                         > total : 290
                         - performance 4, 1 athletic, so :            +  50pts
                         > total: 340
                         - athletic1 deletion : his performances are deleted when he was alone, so the performance 4 is deleted ; but the deletion doesn't change points total
                         > total : 340
                         - performance 5, 1 athletic, so :            +  70pts
                         > total : 410
                         - performance 2 deletion, so :               -  60pts
                         > total : 350
                         - sport deletion : all sport's performances are deleted ; but the deletion doesn't change points total
                         > total : 350
                         */
                        XCTAssert(pot.points == 350)
                    case .failure(_):
                        XCTFail()
                    }
                }
            case .failure(_):
                XCTFail()
            }
        }
        
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
