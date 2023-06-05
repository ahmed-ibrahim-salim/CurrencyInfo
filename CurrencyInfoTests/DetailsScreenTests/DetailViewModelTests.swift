//
//  DetailViewModelTests.swift
//  CurrencyInfoTests
//
//  Created by magdy khalifa on 05/06/2023.
//

import XCTest
import RxTest
import RxSwift

@testable import CurrencyInfo

final class DetailViewModelTests: XCTestCase {
    
    fileprivate var historicalDataServiceMock: HistoricalDataServiceMock!
    var sut: DetailViewModel!
    private var historicalInputData: HistoricalRequestData!
    private var historicalOutputData: HistoricalDataModel!

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        historicalDataServiceMock = HistoricalDataServiceMock()
        
        sut = DetailViewModel(historicalDataService: historicalDataServiceMock)
        
        
        historicalInputData = HistoricalRequestData(date: sut.getDate(value: -1),
                                                       fromCurrency: CurrencyRate(iso: "USD", rate: 1.3),
                                                       toCurrencyRate: CurrencyRate(iso: "AED", rate: 2.5))
        
        historicalOutputData = HistoricalDataModel(success: true,
                                                   timestamp: 123,
                                                   historical: false,
                                                   base: "EUR",
                                                   date: "2020",
                                                   rates: ["USD": 1.2])
    }

    override func tearDownWithError() throws {
        historicalDataServiceMock = nil
        sut = nil
        scheduler = nil
        disposeBag = nil
        historicalInputData = nil
//        historicalOutputData = nil
    }
    
    func test_getHistoricalDataForDay_ReturnsData() {

//        let historyData = scheduler.createObserver(HistoricalDataModel.self)

        let exp = expectation(description: "Loading Historical data")

        
        // when
        historicalDataServiceMock.resultMock = .success(historicalOutputData)

        var resultData: HistoricalDataModel?
        
        sut.getHistoricalDataForDay(historicalData: historicalInputData) {  result in
            
            switch result {
            case .success(let data):
                resultData = data
            case .failure:
                break
            }
            
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)


        // Then
        XCTAssertEqual(resultData, historicalOutputData)
    }
    
    func test_getHistoricalDataForDay_CanRaisesError() {

        let exp = expectation(description: "Loading Historical data")

        // when
        let error = ErrorResult.network(string: "network error")

        historicalDataServiceMock.resultMock = .failure(error)


        var errorResult: ErrorResult?
        
        sut.getHistoricalDataForDay(historicalData: historicalInputData) {  result in
            
            switch result {
            case .success(let data):
               break
            case .failure(let innerError):
                errorResult = innerError
            }
            
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)


        // Then
        XCTAssertEqual(errorResult, error)
    }
    
    func test_getHistoricalDataForPast3Days_WhenThereIsError_RaisesError() {
        

        let historyData = scheduler.createObserver([CurrencyRate].self)
        let errorMessage = scheduler.createObserver(ErrorResult.self)
        
        let error = ErrorResult.network(string: "network error")
        let exp = expectation(description: "Loading Historical data")

        sut.errorMessage
            .subscribe(errorMessage)
            .disposed(by: disposeBag)

        sut.historicalDataLast3Days
            .subscribe(historyData)
            .disposed(by: disposeBag)
        
        
        // when
        scheduler.start()

        historicalDataServiceMock.resultMock = .failure(error)

        sut.getHistoricalDataLast3Days(historicalInputData) {_ in
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
           
        // Then
        XCTAssertEqual(errorMessage.events, [.next(0, error)])

    }
    
    func test_getHistoricalDataForPast3Days_ReturnsData() {
        

        let historyData = scheduler.createObserver([CurrencyRate].self)
        
        let exp = expectation(description: "Loading Historical data")

        sut.historicalDataLast3Days
            .subscribe(historyData)
            .disposed(by: disposeBag)
        
        // when
        scheduler.start()

        historicalDataServiceMock.resultMock = .success(historicalOutputData)
        
        sut.getHistoricalDataLast3Days(historicalInputData) {_ in
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        
        
        guard let rateDictItem = historicalOutputData.rates.first else {return}
        let rate = CurrencyRate(iso: rateDictItem.key, rate: rateDictItem.value)
        let rates = Array(repeating: rate, count: 3)

        
        // Then
        XCTAssertEqual(historyData.events, [.next(0, rates)])

    }
}

private class HistoricalDataServiceMock: HistoricalDataServiceProtocol {
    
    var resultMock: Result<HistoricalDataModel, ErrorResult>?
    
    func getHistoricalData(_ historicalRequestData: HistoricalRequestData, completionHandler: @escaping (Result<HistoricalDataModel, ErrorResult>) -> Void) {
        
        if let result = resultMock {
            completionHandler(result)
        }
    }
    
    
}
