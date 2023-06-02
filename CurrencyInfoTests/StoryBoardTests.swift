//
//  StoryBoardTests.swift
//  CurrencyInfoTests
//
//  Created by Ahmad medo on 02/06/2023.
//


import XCTest
@testable import CurrencyInfo

class StoryboardTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {    }
    
    func test_InitialViewController_IsItemListViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController =
        storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is ConverterScreen)
    }
    
}
