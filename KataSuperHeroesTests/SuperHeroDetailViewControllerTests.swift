//
//  SuperHeroDetailViewControllerTests.swift
//  KataSuperHeroesTests
//
//  Created by Jesus Martin Alonso on 26/9/18.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit

@testable import KataSuperHeroes

class SuperHeroDetailViewControllerTests: AcceptanceTestCase {
    
    fileprivate let repository = MockSuperHeroesRepository()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func test_super_hero_detail_is_shown_properly(){
        
        //Given
        let superHero = givenThereIsOneSuperHero()
        
        //When
        _ = openSuperHeroDetailViewController()
        
        //Then
        
        
        let nameLabel = tester().waitForView(withAccessibilityLabel: "Name: \(superHero.name)") as! UILabel
        expect(nameLabel.text).to(equal(superHero.name))
        
        let descriptionLabel = tester().waitForView(withAccessibilityLabel: "Description: \(superHero.name)") as! UILabel
        expect(descriptionLabel.text).to(equal(superHero.description))
        
        
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
    
    
    
    

    fileprivate func openSuperHeroDetailViewController() -> SuperHeroDetailViewController{
        
        let superHeroeDetailViewController = ServiceLocator().provideSuperHeroDetailViewController("SuperHero - 0") as! SuperHeroDetailViewController
        
        superHeroeDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroeDetailViewController, superHeroName: "SuperHero - 0", getSuperHeroByName: GetSuperHeroByName(repository: repository))
        
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroeDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroeDetailViewController
        
        
    }
    
    
    
}
