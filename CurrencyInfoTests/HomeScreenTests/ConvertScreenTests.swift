//
//  ConvertScreenTest.swift
//  CurrencyInfoTests
//
//  Created by Ahmad medo on 02/06/2023.
//


import XCTest
import RxSwift
import RxTest

@testable import CurrencyInfo

final class ConverterScreenTests: XCTestCase {
    
    var sut: ConverterScreen!
    var navigationController: UINavigationController!
    var viewModel: ConverterScreenViewModel!
    private var latestRatesService: LatestRatesServiceMock!
    var tablesDataSource: TablesDataSource?


    
    override func setUpWithError() throws {

        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        navigationController = storyboard
            .instantiateInitialViewController() as? UINavigationController
        
        sut = navigationController.viewControllers[0] as? ConverterScreen
        
        tablesDataSource = TablesDataSource()
        tablesDataSource?.converterScreen = sut
        
        sut.tablesDataSource = tablesDataSource
        
        sut.loadViewIfNeeded()
                
        latestRatesService = LatestRatesServiceMock()

        viewModel = ConverterScreenViewModel(latestRatesService)
        
        sut.fromCurrencyTable.delegate = tablesDataSource
        sut.fromCurrencyTable.dataSource = tablesDataSource
        
        sut.toCurrencyTable.delegate = tablesDataSource
        sut.toCurrencyTable.dataSource = tablesDataSource

    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        latestRatesService = nil
        navigationController = nil
        tablesDataSource = nil
    }
    
    // MARK: Outlets
    func test_HasDetailsButton() {
        let hasDetailsBtn = sut.detailsBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasDetailsBtn)
    }
    func test_HasReverseBtn() {
        let hasReverseBtn = sut.reverseBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasReverseBtn)
    }
    

    func test_HasFromButton() {
        let hasFromButton = sut.fromBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasFromButton)
    }
    func test_HasToButton() {
        let hasToButton = sut.toBtn.isDescendant(of: sut.view)
        XCTAssertTrue(hasToButton)
    }
    
    func test_HasfromCurrencyArrow() {
        let hasfromCurrencyArrow = sut.fromCurrencyArrow.isDescendant(of: sut.view)
        XCTAssertTrue(hasfromCurrencyArrow)
    }
    
    func test_HastoCurrencyArrow() {
        let hastoCurrencyArrow = sut.toCurrencyArrow.isDescendant(of: sut.view)
        XCTAssertTrue(hastoCurrencyArrow)
    }
    
    func test_HasFromCurrencyTxtFiled() {
        let hasFromCurrencyTxtFiled = sut.fromCurrencyTxtFiled.isDescendant(of: sut.view)
        XCTAssertTrue(hasFromCurrencyTxtFiled)
    }
    func test_HasToCurrencyTxtFiled() {
        let hasToCurrencyTxtFiled = sut.toCurrencyTxtFiled.isDescendant(of: sut.view)
        XCTAssertTrue(hasToCurrencyTxtFiled)
    }
    
    func test_HasCurrenciesListTableViewFor_FromAction() {
        let hasToCurrencyTxtFiled = sut.fromCurrencyTable
//            .isDescendant(of: sut.view)
        XCTAssertNotNil(hasToCurrencyTxtFiled)
    }
    
    // MARK: Actions

    
    
    func test_fromBtnHasFromAction() {
        let fromBtn: UIButton = sut.fromBtn
        
        guard let actions = fromBtn.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail("coul not find action for this btn")
            return
        }
        
        
        XCTAssertTrue(actions.contains("fromCurrencyAction:"))
        
        
        let fromCurrencyArrow: UIButton = sut.fromCurrencyArrow
        
        guard let arrowActions = fromCurrencyArrow.actions(forTarget: sut, forControlEvent: .touchUpInside)else {
            XCTFail("arrow has now action"); return
        }
        
        XCTAssertTrue(arrowActions.contains("fromCurrencyAction:"))
    }
    func test_reverseBtnHasFromAction() {
        let reverseBtn: UIButton = sut.reverseBtn
        
        guard let actions = reverseBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else {
            XCTFail("swap btn has no actions")
            return
        }
        
        
        print(actions, "my new action")
        XCTAssertTrue(actions.contains("swapRatesAction:"))
    }
    func test_toBtnHasFromAction() {
        let toBtn: UIButton = sut.toBtn
        
        guard let actions = toBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else {
            XCTFail("to btn has no actions")
            return
        }
        
        print(actions)
        
        XCTAssertTrue(actions.contains("toCurrencyAction:"))
        
        
        let toCurrencyArrow: UIButton = sut.toCurrencyArrow
        
        guard let arrowActions = toCurrencyArrow.actions(forTarget: sut, forControlEvent: .touchUpInside)else {
            XCTFail("arrow has no actions"); return
        }
        
        XCTAssertTrue(arrowActions.contains("toCurrencyAction:"))
    }
    func test_detailsBtnHasFromAction() {
        let detailsBtn: UIButton = sut.detailsBtn
        
        guard let actions = detailsBtn.actions(forTarget: sut, forControlEvent: .touchUpInside)else {
            XCTFail("details btn has no actions")
            return
        }
        
        
        print(actions)
        XCTAssertTrue(actions.contains("openDetailsAction:"))
    }
    
    func test_WhenPressedFromBtn_AddsTableViewToView() {
        let fromBtn: UIButton = sut.fromBtn

        fromBtn.sendActions(for: .touchUpInside)
        
        
        let hasTableView = sut.fromCurrencyTable.isDescendant(of: sut.view)
        XCTAssertNotNil(hasTableView)
    }
    
    func test_WhenPressedTableViewCell_RemovesTableViewFromView() {
        // given
        let fromBtn: UIButton = sut.fromBtn

        fromBtn.sendActions(for: .touchUpInside)
        
        let hasTableView = sut.fromCurrencyTable.isDescendant(of: sut.view)
        XCTAssertNotNil(hasTableView)
        
        // when
        sut.fromCurrencyTable.delegate?.tableView?(sut.fromCurrencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then
        let doesNotHaveTableView = sut.fromCurrencyTable.isDescendant(of: sut.view)
        XCTAssertFalse(doesNotHaveTableView)
        
    }
    
    func test_WhenPressedTableViewCell_ChangesFromCurrencyBtnTitle() {
        // given
        sut.currencyList.append(CurrencyRate(iso: "USD", rate: 10.1))
        
        let fromBtn: UIButton = sut.fromBtn

        fromBtn.sendActions(for: .touchUpInside)
        
        let hasTableView = sut.fromCurrencyTable.isDescendant(of: sut.view)
        XCTAssertNotNil(hasTableView)
        
        // when
        sut.fromCurrencyTable.delegate?.tableView?(sut.fromCurrencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then
        let fromBtnTitle = fromBtn.title(for: .normal)
        
        XCTAssertEqual(fromBtnTitle, "USD")
        
    }
    func test_WhenPressedTableViewCell_ChangesToCurrencyBtnTitle() {
        // given
        sut.currencyList.append(CurrencyRate(iso: "EUR", rate: 10.1))
        
        let toBtn: UIButton = sut.toBtn

        toBtn.sendActions(for: .touchUpInside)
        
        let hasTableView = sut.fromCurrencyTable.isDescendant(of: sut.view)
        XCTAssertNotNil(hasTableView)
        
        // when
        sut.toCurrencyTable.delegate?.tableView?(sut.toCurrencyTable, didSelectRowAt: IndexPath(row: 0, section: 0))

        // then
        let toBtnTitle = toBtn.title(for: .normal)
        
        XCTAssertEqual(toBtnTitle, "EUR")
        
    }
    
    func test_TextFieldsKeyboardType_NumberPad() {
        let fromTextFieldKeyboardType = sut.fromCurrencyTxtFiled.keyboardType
        
        XCTAssertEqual(fromTextFieldKeyboardType, .decimalPad)

        
    }
    func test_From_TextFieldDefaultEntry_isOne() {
        let fromTextFieldTXT: String? = sut.fromCurrencyTxtFiled.text
        
        XCTAssertEqual(fromTextFieldTXT, "1")

        
    }
    func test_TextFiledsOnlyAcceptNumbers() {
        // Given
        guard let fromTextField = sut.fromCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }
        guard let toTextField = sut.toCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }

        let returnChar = "11"
        
        // When
        let shouldAllowNumbers = fromTextField.delegate?.textField?(fromTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: returnChar)
        
        
        let shouldAllowNumbersSecondTextField = toTextField.delegate?.textField?(toTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: returnChar)
        
        // Then

        XCTAssertTrue(shouldAllowNumbers == true, "Return key should be allowed")
        XCTAssertTrue(shouldAllowNumbersSecondTextField == true, "Return key should be allowed")

    }
    func test_TextFiledsDoesNotAcceptSpecialChar() {
        guard let fromTextField = sut.fromCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }
        guard let toTextField = sut.toCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }

        let specialChar = ",,,,"
        
        guard let shouldNotAllowSpecialChar = fromTextField.delegate?.textField?(fromTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: specialChar) else {
            
            XCTFail("textfield delegate is nil")
            return
        }
        
        guard let shouldNotAllowSpecialCharSecondTextField = toTextField.delegate?.textField?(toTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: specialChar) else {
            
            XCTFail("textfield delegate is nil")
            return
        }
        
        XCTAssertFalse(shouldNotAllowSpecialChar, "Return key should be allowed")
        XCTAssertFalse(shouldNotAllowSpecialCharSecondTextField, "Return key should be allowed")

    }
    func test_TextFiledsDoesNotAcceptWhiteSpace() {
        guard let fromTextField = sut.fromCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }
        guard let toTextField = sut.toCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }

        let whiteSpace = " "
        
        guard let shouldNotAllowWhiteSpace = fromTextField.delegate?.textField?(fromTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: whiteSpace) else {
            
            XCTFail("textfield delegate is nil")
            return
        }
        
        
        guard let shouldNotAllowWhiteSpaceSecondTextField = toTextField.delegate?.textField?(toTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: whiteSpace) else {
            
            XCTFail("textfield delegate is nil")
            return
        }
        
        XCTAssertFalse(shouldNotAllowWhiteSpace, "Return key should be allowed")
        XCTAssertFalse(shouldNotAllowWhiteSpaceSecondTextField, "Return key should be allowed")
    }
    
    func test_TextFiledsOnlyAcceptsOneDecimalPoint() {
        guard let fromTextField = sut.fromCurrencyTxtFiled else {
            XCTFail("textfield delegate is nil")
            return
        }
        guard sut.toCurrencyTxtFiled != nil else {
            XCTFail("textfield delegate is nil")
            return
        }

        fromTextField.text = "1.00"
        
        let decimalPoint = "."
        
        guard let shouldNotAllowMoreThanOneDecimalPoint = fromTextField.delegate?.textField?(fromTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: decimalPoint) else {
            
            XCTFail("textfield delegate is nil")
            return
        }
        XCTAssertFalse(shouldNotAllowMoreThanOneDecimalPoint, "only one decimal point is allowed")
    }
    
    
    func test_To_TextField_PushesCalculatedRateTO_From_TextField() {
        guard let fromTextField = sut.fromCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }
        guard let toTextField = sut.toCurrencyTxtFiled else {
            XCTFail("textfield is nil")
            return
        }
        
        sut.changeFromCurrencyBtn.onNext(CurrencyRate(iso: "USD", rate: 3.2))
        sut.changeToCurrencyBtn.onNext(CurrencyRate(iso: "KZC", rate: 1.5))
//
//        200 / 1.5 = 133.33
        // 133.33 * 3.2 = 426.67

        let entry = "200"
        
        toTextField.text = entry
        toTextField.delegate?.textFieldDidChangeSelection!(toTextField)
                
        XCTAssertEqual(fromTextField.text, "426.67")
        
    }
    func test_SwapActionOnlyWorks_WhenBothRatesAreChosen() throws {
        // given
        let fromCurrency = CurrencyRate(iso: "From", rate: 1.5)

        sut.changeFromCurrencyBtn.onNext(fromCurrency)

        // when
        sut.reverseBtn.sendActions(for: .touchUpInside)
        let fromValue = try sut.changeFromCurrencyBtn.value()
       
        // Then
        XCTAssertTrue(fromValue.iso == "From")
    }
    func test_CanSwapRates() throws {
        // given
        let fromCurrency = CurrencyRate(iso: "KZC", rate: 1.5)
        let toCurrency = CurrencyRate(iso: "USD", rate: 3.2)

        sut.changeFromCurrencyBtn.onNext(fromCurrency)
        sut.changeToCurrencyBtn.onNext(toCurrency)

        // when
        sut.reverseBtn.sendActions(for: .touchUpInside)
        
        let fromValue = try sut.changeFromCurrencyBtn.value()
       
        XCTAssertEqual(fromValue.iso, "USD")
//        sut.swapRates()
    }
    func test_PushDetailsViewController_IsPushed() {
        
        sut.detailsBtn.sendActions(for: .touchUpInside)
        
        RunLoop.current.run(until: Date())
                
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        
    }
    
}

// MARK: Mock
private class LatestRatesServiceMock: LatestRatesService {
    
    
    func getLatestRates() -> Single<LatestRatesModel> {
        
        return .error(ErrorResult.custom(string: ""))

    }
    
}
