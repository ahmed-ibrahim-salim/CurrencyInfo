//
//  DetailsViewControllerTests.swift
//  CurrencyInfoTests
//
//  Created by magdy khalifa on 04/06/2023.
//

import XCTest
@testable import CurrencyInfo

final class DetailViewControllerTests: XCTestCase {
    
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
        
        converterScreen.detailsBtn.sendActions(for: .touchUpInside)
        
        RunLoop.current.run(until: Date())

        sut = navigationController.viewControllers[1] as? DetailViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
    }

    func test_HasOtherCurrenciesTableView(){
        let HasOtherCurrenciesTableView = sut.otherCurrenciesTableView.isDescendant(of: sut.view)
        XCTAssertTrue(HasOtherCurrenciesTableView)
    }
    func test_HasHistoricalTableView(){
        let HasHistoricalTableView = sut.historicalTableView.isDescendant(of: sut.view)
        XCTAssertTrue(HasHistoricalTableView)
    }
    func test_HasCharView(){
        let HasChartView = sut.charView.isDescendant(of: sut.view)
        XCTAssertTrue(HasChartView)
    }

}
