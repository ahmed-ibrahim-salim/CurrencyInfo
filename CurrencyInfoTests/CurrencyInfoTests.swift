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
    private var availableCurrenciesService: AvailableCurrenciesServiceMock!
//    private var latestRatesService: LatestRatesServiceMock!

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!


    override func setUpWithError() throws {

        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        availableCurrenciesService = AvailableCurrenciesServiceMock()
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
        let rates = scheduler.createObserver([Currency].self)
        let errorMessage = scheduler.createObserver(ErrorResult.self)
        
        sut.output.error
            .drive(errorMessage)
            .disposed(by: disposeBag)

        sut.output.availlableRates
            .drive(rates)
            .disposed(by: disposeBag)
        
    
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.viewDidRefresh)
            .disposed(by: disposeBag)

        scheduler.start()
                
        XCTAssertEqual(errorMessage.events, [.next(10, ErrorResult.custom(string: "The operation couldn’t be completed. (CurrencyInfo.ErrorResult error 2.)"))])
    
    }
    
}




class AvailableCurrenciesServiceMock: AvailableCurrenciesService{
    
    
    
    func getAvailableSymbols() -> Single<AvailableCurrenciesModel> {
        
        return Single.error(ErrorResult.custom(string: "error"))
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

