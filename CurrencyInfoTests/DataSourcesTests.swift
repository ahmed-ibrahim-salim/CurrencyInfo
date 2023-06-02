//
//  DataSourcesTests.swift
//  CurrencyInfoTests
//
//  Created by Ahmad medo on 03/06/2023.
//

import XCTest
@testable import CurrencyInfo

final class DataSourcesTests: XCTestCase {

    var sut: TablesDataSource!
    
    private var controllerMock: ConverterScreenViewControllerMock!
    
    override func setUpWithError() throws {
        

        sut = TablesDataSource()
        
        controllerMock = ConverterScreenViewControllerMock(fromCurrencyTable: UITableView(), currencyList: [])
        
        sut.converterScreen = controllerMock
        
        sut.converterScreen.fromCurrencyTable.delegate = sut
        sut.converterScreen.fromCurrencyTable.dataSource = sut
    }

    override func tearDownWithError() throws {
        sut = nil
        controllerMock = nil
    }
    
    func test_sutHasController(){
        
        XCTAssertNotNil(sut.converterScreen)
    }
    func test_TableDataSource_WhenCurrencyListIsEmpty_ReturnsZeroRows(){


        
        sut.converterScreen.
    }
    
}

// MARK: Mock


fileprivate class ConverterScreenViewControllerMock: ConverterScreenControllerProtocol{
    
    var fromCurrencyTable: UITableView!
    
    var currencyList: [CurrencyRate]
    
    init(fromCurrencyTable: UITableView!, currencyList: [CurrencyRate]) {
        self.fromCurrencyTable = fromCurrencyTable
        self.currencyList = currencyList
       

    }
    
}
