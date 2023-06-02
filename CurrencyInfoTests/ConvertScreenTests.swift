//
//  ConvertScreenTest.swift
//  CurrencyInfoTests
//
//  Created by Ahmad medo on 02/06/2023.
//


import XCTest
import RxSwift


@testable import CurrencyInfo

final class ConverterScreenTests: XCTestCase {
    
    var sut: ConverterScreen!
    var navigationController: UINavigationController!
    var viewModel: ConverterScreenViewModel!
    private var latestRatesService: LatestRatesServiceMock!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        navigationController = storyboard
            .instantiateInitialViewController() as? UINavigationController
        
        sut = navigationController.viewControllers[0] as? ConverterScreen
        
        sut.loadViewIfNeeded()
                
        latestRatesService = LatestRatesServiceMock()

        viewModel = ConverterScreenViewModel(latestRatesService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        latestRatesService = nil
        navigationController = nil
    }
    
    // MARK: Outlets
    func test_HasDetailsButton(){
        let hasDetailsBtn = sut.detailsBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasDetailsBtn)
    }
    func test_HasReverseBtn(){
        let HasReverseBtn = sut.reverseBtn.isDescendant(of: sut.view)
        XCTAssertTrue(HasReverseBtn)
    }
    

    func test_HasFromButton(){
        let hasFromButton = sut.fromBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasFromButton)
    }
    func test_HasToButton(){
        let hasToButton = sut.toBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasToButton)
    }
    
    func test_HasfromCurrencyArrow(){
        let hasfromCurrencyArrow = sut.fromCurrencyArrow.isDescendant(of: sut.view)
        XCTAssertTrue(hasfromCurrencyArrow)
    }
    
    func test_HastoCurrencyArrow(){
        let hastoCurrencyArrow = sut.toCurrencyArrow.isDescendant(of: sut.view)
        XCTAssertTrue(hastoCurrencyArrow)
    }
    
    func test_HasFromCurrencyTxtFiled(){
        let hasFromCurrencyTxtFiled = sut.fromCurrencyTxtFiled.isDescendant(of: sut.view)
        XCTAssertTrue(hasFromCurrencyTxtFiled)
    }
    func test_HasToCurrencyTxtFiled(){
        let hasToCurrencyTxtFiled = sut.toCurrencyTxtFiled.isDescendant(of: sut.view)
        XCTAssertTrue(hasToCurrencyTxtFiled)
    }
    
    
    // MARK: Actions
    func test_fromBtnHasFromAction(){
        let fromBtn: UIButton = sut.fromBtn
        
        guard let actions = fromBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail()
            return
        }
        
        
        XCTAssertTrue(actions.contains("fromCurrencyAction:"))
        
        
        let fromCurrencyArrow: UIButton = sut.fromCurrencyArrow
        
        guard let arrowActions = fromCurrencyArrow.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail(); return
        }
        
        XCTAssertTrue(arrowActions.contains("fromCurrencyAction:"))
    }
    func test_reverseBtnHasFromAction(){
        let reverseBtn: UIButton = sut.reverseBtn
        
        guard let actions = reverseBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail()
            return
        }
        
        
        print(actions)
        XCTAssertTrue(actions.contains("reverseAction:"))
    }
    func test_toBtnHasFromAction(){
        let toBtn: UIButton = sut.toBtn
        
        guard let actions = toBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail()
            return
        }
        
        print(actions)
        
        XCTAssertTrue(actions.contains("toCurrencyAction:"))
        
        
        let toCurrencyArrow: UIButton = sut.toCurrencyArrow
        
        guard let arrowActions = toCurrencyArrow.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail(); return
        }
        
        XCTAssertTrue(arrowActions.contains("toCurrencyAction:"))
    }
    func test_detailsBtnHasFromAction(){
        let detailsBtn: UIButton = sut.detailsBtn
        
        guard let actions = detailsBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else{
            XCTFail()
            return
        }
        
        
        print(actions)
        XCTAssertTrue(actions.contains("openDetailsAction:"))
    }

    
}

// MARK: Mock
fileprivate class LatestRatesServiceMock: LatestRatesService{
    func getLatestRates() -> RxSwift.Single<CurrencyInfo.LatestRatesModel> {
        return Single.error(ErrorResult.custom(string: ""))
    }
    
}
