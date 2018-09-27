//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()

    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    
    func test_hide_empty_case_if_there_is_superheroes(){
        
        _ = givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
//        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
        
        
    }
    
    func test_the_title_of_the_app_is_right(){
        
        openSuperHeroesViewController()
        
        tester().waitForView(withAccessibilityLabel: "Kata Super Heroes")
        
    }
    
    
    
    func test_shows_one_card_if_there_is_one_superheroe(){
        
        //Given
        let superhero = givenThereIsOneSuperHero()
        
        //When
        let viewController = openSuperHeroesViewController()
        
        
        //Then
        let superHeroCell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
        
        expect(superHeroCell.nameLabel.text).to(equal(superhero.name))
        
        
        
        
        
    }
    
    func test_shows_more_than_one_superheroe(){
        
        //Given
        let superheroes = givenThereAreSomeSuperHeroes(10)
        
        //When
        let viewController = openSuperHeroesViewController()
        
        //Then

        for i in 0..<superheroes.count {
            
            let superHeroCell =  tester().waitForCell(at: IndexPath(row: i, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
            
            expect(superHeroCell.nameLabel.text).to(equal(superheroes[i].name))
        }
        
        
        
    }
    
    
    func test_shows_badge_when_one_superheroe_is_an_avenger(){
        
        //Given
        _ = givenThereAreSomeSuperHeroes(1, avengers: true)
        
        //When
        let viewController = openSuperHeroesViewController()
        
        //Then
        let superheroCell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
        expect(superheroCell.avengersBadgeImageView.isHidden).to(beFalse())
        
        
    }
    
    func test_does_not_show_avenger_badge_when_one_superheroe_is_not_an_avenger(){
        
        //Given
        _ = givenThereAreSomeSuperHeroes(1, avengers: false)
        
        //When
        let viewController = openSuperHeroesViewController()
        
        //Then
        let superheroCell = tester().waitForCell(at: IndexPath(row: 0, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
        expect(superheroCell.avengersBadgeImageView.isHidden).to(beTrue())
        
    }
    
    
//    func test_shows_avenger_when_10_superheroes_are_avengers(){
//        let avengers = givenThereAreSomeSuperHeroes(5, avengers: true)
//        let notAvengers = givenThereAreSomeSuperHeroes(5, avengers: false)
//
//
//        //When
//        let viewController = openSuperHeroesViewController()
//
//        //Then
//
//        for i in 0..<notAvengers.count {
//            let superheroCell =  tester().waitForCell(at: IndexPath(row: i, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
//            expect(superheroCell.avengersBadgeImageView.isHidden).to(beTrue())
//        }
//
//        for i in 5..<5+avengers.count {
//            let superheroCell =  tester().waitForCell(at: IndexPath(row: i, section: 0), in: viewController.tableView) as! SuperHeroTableViewCell
//            expect(superheroCell.avengersBadgeImageView.isHidden).to(beFalse())
//        }
//
//
//
//    }
    
    
    func test_goes_to_detail_when_click_on_one_superheroe(){
        
        //Given
        _ = givenThereIsOneSuperHero()
        
        //When
        let viewController = openSuperHeroesViewController()
        
        tester().waitForView(withAccessibilityLabel: "SuperHero - 0")
        _  = tester().tapRow(at: IndexPath(row: 0, section: 0), in: viewController.tableView)
        
        //Then
        tester().waitForView(withAccessibilityLabel: "SuperHero - 0")
        
        
    }
    
    
    
    
    
    
    //MARK: - Private functions
    

    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }
    
    fileprivate func givenThereIsOneSuperHero() -> SuperHero{
         return  givenThereAreSomeSuperHeroes(1).first!
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }
    
    
//    fileprivate func givenThereAreSomeSuperHeroes(_ avengers : Int, notAvengers : Int) -> [SuperHero]{
//
//
//
//    }

    @discardableResult
    fileprivate func openSuperHeroesViewController() -> SuperHeroesViewController {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroesViewController
    }
}
