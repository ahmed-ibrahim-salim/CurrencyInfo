//
//  CurrencyInfoTests.swift
//  CurrencyInfoTests
//
//  Created by magdy khalifa on 31/05/2023.
//

import XCTest
import RxTest
import RxSwift

@testable import CurrencyInfo

final class CurrencyInfoTests: XCTestCase {

    private var sut: ConverterScreenViewModel!
    private var availableCurrenciesService: AvailableCurrenciesServiceMockWithError!
//    private var latestRatesService: LatestRatesServiceMock!

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!


    override func setUpWithError() throws {

        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        availableCurrenciesService = AvailableCurrenciesServiceMockWithError()
//        latestRatesService = LatestRatesServiceMock()

        sut = ConverterScreenViewModel(availableCurrenciesService: availableCurrenciesService)
//        ConverterScreenViewModel(availableCurrenciesService: availableCurrencies,
//                                       LatestRatesService: latestRatesService)
    }

    override func tearDownWithError() throws {
        sut = nil
//        availableCurrencies = nil
//        latestRatesService = nil
    }

    func test_WhenCallGetAvailableCurrencies_WithError_ReturnsError(){
        // given
        let rates = scheduler.createObserver([Currency].self)
        let errorMessage = scheduler.createObserver(ErrorResult.self)
        
        sut.output.error
            .drive(errorMessage)
            .disposed(by: disposeBag)

        sut.output.availlableRates
            .drive(rates)
            .disposed(by: disposeBag)
        
    // When
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.viewDidRefresh)
            .disposed(by: disposeBag)

        scheduler.start()
           
        // Then
        XCTAssertEqual(errorMessage.events, [.next(10, ErrorResult.custom(string: "The operation couldn’t be completed. (CurrencyInfo.ErrorResult error 2.)"))])
    
    }
    func test_WhenCalledRefreshWithNoCurrencies_ReturnsEmptyCurrencies() {
        // Given
        // create scheduler
        let rates = scheduler.createObserver([Currency].self)
        
        sut.output.availlableRates
            .drive(rates)
            .disposed(by: disposeBag)
        
        // when
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.viewDidRefresh)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        // gets no events
        XCTAssertEqual(rates.events, [])
    }
    
    func testFetchCurrencies() {
        
        // Given
        // create scheduler
        let rates = scheduler.createObserver([Currency].self)
        
        // giving a service mocking currencies
        let availableCurrenciesModel = AvailableCurrenciesModel(success: true, symbols: [Currency.USD.rawValue : ""])
        
        availableCurrenciesService.availableCurrenciesModel = availableCurrenciesModel
        
        let availableSymbols = availableCurrenciesModel.symbols.map({Currency(rawValue: $0.key)}).compactMap({$0})
        
        
        // bind the result
        sut.output.availlableRates
            .drive(rates)
            .disposed(by: disposeBag)
        
        // When
        // mock a reload
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.viewDidRefresh)
            .disposed(by: disposeBag)
        
        scheduler.start()
        // Then
        XCTAssertEqual(rates.events, [.next(10, availableSymbols)])
    }

}


class AvailableCurrenciesServiceMockWithError: AvailableCurrenciesService{
    
    var availableCurrenciesModel: AvailableCurrenciesModel? = nil
    
    func getAvailableSymbols() -> Single<AvailableCurrenciesModel> {
        if let availableCurrenciesModel = availableCurrenciesModel {
            
            return .just(availableCurrenciesModel)
            
        } else {
            
            return Single.error(ErrorResult.custom(string: "error"))
        }
    }
}

//
//
////
//class LatestRatesServiceMock: LatestRatesService{
//    var getLatestRatesResultMock: Result<Single<AvailableCurrenciesModel>, ErrorResult>?
//
//    func getLatestRates(completion: @escaping (Result<Single<AvailableCurrenciesModel>, ErrorResult>) -> Void) {
//
//        if let result = getLatestRatesResultMock{
//            completion(result)
//        }
//    }
//
//
//}

