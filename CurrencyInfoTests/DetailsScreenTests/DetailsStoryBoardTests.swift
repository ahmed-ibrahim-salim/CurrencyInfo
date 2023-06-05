//
//  StoryBoardTests.swift
//  CurrencyInfoTests
//
//  Created by Ahmed medo on 04/06/2023.
//

import XCTest
@testable import CurrencyInfo

final class StoryBoardTests: XCTestCase {
    
    var navigationController: UINavigationController!
    var converterScreen: ConverterScreen!
    var sut: DetailViewController!
    
    
    override func setUpWithError() throws {
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        navigationController = storyboard
            .instantiateInitialViewController() as? UINavigationController
        
        converterScreen = navigationController.viewControllers[0] as? ConverterScreen
        converterScreen.loadViewIfNeeded()
        
        converterScreen.changeFromCurrencyBtn.onNext(CurrencyRate(iso: "USD", rate: 1.2))
        converterScreen.changeToCurrencyBtn.onNext(CurrencyRate(iso: "EUR", rate: 1.2))

        converterScreen.detailsBtn.sendActions(for: .touchUpInside)
        
        RunLoop.current.run(until: Date())

        sut = navigationController.viewControllers[1] as? DetailViewController
        
        sut.loadViewIfNeeded()
        
    }

    override func tearDownWithError() throws {
        navigationController = nil
        converterScreen = nil
        sut = nil
    }
    
    func test_HasOtherCurrenciesTableView() {
        let hasOtherCurrenciesTableView = sut.otherCurrenciesTableView.isDescendant(of: sut.view)
        XCTAssertTrue(hasOtherCurrenciesTableView)
    }
    func test_HasHistoricalTableView() {
        let hasHistoricalTableView = sut.historicalTableView.isDescendant(of: sut.view)
        XCTAssertTrue(hasHistoricalTableView)
    }
    func test_HasCharView() {
        let hasChartView = sut.charView.isDescendant(of: sut.view)
        XCTAssertTrue(hasChartView)
    }



}
