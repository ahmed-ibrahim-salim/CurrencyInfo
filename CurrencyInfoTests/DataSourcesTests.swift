//
//  DataSourcesTests.swift
//  CurrencyInfoTests
//
//  Created by Ahmad medo on 03/06/2023.
//

import XCTest
import RxSwift

@testable import CurrencyInfo

final class DataSourcesTests: XCTestCase {

    var sut: TablesDataSource!
    var fromCurrencyTable: UITableView!
    var toCurrencyTable: UITableView!

    private var controllerMock: ConverterScreenViewControllerMock!
    
    override func setUpWithError() throws {
        
        controllerMock = ConverterScreenViewControllerMock(fromCurrencyTable: UITableView(), toCurrencyTable: UITableView(),
                                                           currencyList: [])

        
        sut = TablesDataSource()
        sut.converterScreen = controllerMock
        
        
        fromCurrencyTable = controllerMock.fromCurrencyTable
        toCurrencyTable = controllerMock.toCurrencyTable
        
        fromCurrencyTable.dataSource = sut
        fromCurrencyTable.delegate = sut
        
        toCurrencyTable.dataSource = sut
        toCurrencyTable.delegate = sut
    }

    override func tearDownWithError() throws {
        sut = nil
        controllerMock = nil
    }
    
    func test_sutHasController(){
        
        XCTAssertNotNil(sut.converterScreen)
    }
    func test_NumberOfRows_CurrencyRatesCount(){

        controllerMock.currencyList.append(CurrencyRate(iso: "", rate: 10.1))
        
        XCTAssertEqual(fromCurrencyTable.numberOfRows(inSection: 0), 1)

        XCTAssertEqual(toCurrencyTable.numberOfRows(inSection: 0), 1)

    }
    func test_CellForRow_ReturnsCurrencyRateCell(){
        
        controllerMock.currencyList.append(CurrencyRate(iso: "", rate: 10.1))
        
        fromCurrencyTable.reloadData()
        
        let cell = fromCurrencyTable.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell)
    }
    
    func test_ConfigCellWithCurrencyRate_CallsConfigCellWithPassedCurrencyItem(){

        controllerMock.currencyList.append(CurrencyRate(iso: "USD", rate: 10.1))
        fromCurrencyTable.reloadData()
        
        let cell = fromCurrencyTable.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell?.textLabel?.text, "USD")
    }

}

// MARK: Mock

fileprivate class ConverterScreenViewControllerMock: ConverterScreenControllerProtocol{

    var changeFromBtnName = PublishSubject<CurrencyRate>()
    
    var changeToBtnName = PublishSubject<CurrencyRate>()
    
    
    
    var fromBtn: UIButton!
    
    var toBtn: UIButton!
    
    
    var fromCurrencyTable: UITableView!
    var toCurrencyTable: UITableView!
    
    var currencyList: [CurrencyRate]
//    
    init(fromCurrencyTable: UITableView!,
         toCurrencyTable: UITableView!,
         currencyList: [CurrencyRate]) {
        
        
        self.fromCurrencyTable = fromCurrencyTable
        self.toCurrencyTable = toCurrencyTable
        self.currencyList = currencyList
        

        
    }
    
}
