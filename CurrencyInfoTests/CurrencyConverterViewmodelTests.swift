//
//  CurrencyInfoTests.swift
//  CurrencyInfoTests
//
//  Created by magdy khalifa on 31/05/2023.
//

import XCTest
import RxSwift
import RxTest

@testable import CurrencyInfo

final class CurrencyInfoTests: XCTestCase {

    private var sut: ConverterScreenViewModel!
    private var availableCurrencies: AvailableCurrenciesServiceMock!
    private var latestRatesService: LatestRatesServiceMock!
    
    override func setUpWithError() throws {
        
        availableCurrencies = AvailableCurrenciesServiceMock()
        latestRatesService = LatestRatesServiceMock()
        
        sut = ConverterScreenViewModel(availableCurrenciesService: availableCurrencies,
                                       LatestRatesService: latestRatesService)
    }

    override func tearDownWithError() throws {
        sut = nil
        availableCurrencies = nil
        latestRatesService = nil
    }
    
    func test_WhenCalledAvailableCurrenciesService_PushesOnNextEvent(){
        // Given
        let availableCurrenciesModel = AvailableCurrenciesModel(success: true,
                                                                symbols: ["USD" : "United States Dollar"])
        availableCurrencies.getAvailableCurrenciesMockResult = .success(availableCurrenciesModel)
        
        // When
        

        
        sut.getAvailableCurrencies()
        
        // Then
        
        sut.availableCurrencies.asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {_ in}).dispose()
    }
    
    
//    func test_WhenCalledlatestRatesService_PushesOnNextEvent(){
//        // Given
//        let latestRatesModel = LatestRatesModel(success: true,
//                                                timestamp: 2,
//                                                base: "EUR",
//                                                date: "",
//                                                rates: ["USD" : 1.113])
//
//
//        // When
//
//
//        // Then
//    }
}

class AvailableCurrenciesServiceMock: AvailableCurrenciesService{
    
    var getAvailableCurrenciesMockResult: Result<CurrencyInfo.AvailableCurrenciesModel, Error>?
    
    func getAvailableCurrencies(completionHandler: @escaping (Result<CurrencyInfo.AvailableCurrenciesModel, Error>) -> Void) {
        
        if let result = getAvailableCurrenciesMockResult{
            completionHandler(result)
        }
    }
}


class LatestRatesServiceMock: LatestRatesService{
    var getLatestRatesResultMock: Result<CurrencyInfo.LatestRatesModel, Error>?
    
    func getLatestRates(completionHandler: @escaping (Result<CurrencyInfo.LatestRatesModel, Error>) -> Void) {
        if let result = getLatestRatesResultMock{
            completionHandler(result)
        }
    }
    
    
}
