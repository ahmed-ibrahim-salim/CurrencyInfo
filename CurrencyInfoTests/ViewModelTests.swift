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

final class ViewModelTests: XCTestCase {

    private var sut: ConverterScreenViewModel!
    private var latestRatesService: LatestRatesServiceMock!

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!


    override func setUpWithError() throws {


        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        latestRatesService = LatestRatesServiceMock()

        sut = ConverterScreenViewModel(latestRatesService)

    }

    override func tearDownWithError() throws {
        sut = nil
        latestRatesService = nil
    }

    func test_WhenCallGetAvailableCurrencies_WithError_ReturnsError(){
        // given
        let rates = scheduler.createObserver([CurrencyRate].self)
        let errorMessage = scheduler.createObserver(String.self)
        
        sut.output.error
            .drive(errorMessage)
            .disposed(by: disposeBag)

        sut.output.rates
            .drive(rates)
            .disposed(by: disposeBag)
        
    // When
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.reload)
            .disposed(by: disposeBag)

        scheduler.start()
           
        // Then
        XCTAssertEqual(errorMessage.events, [.next(10, "error")])
    
    }
    func test_WhenCalledRefreshWithNoCurrencies_ReturnsEmptyCurrencieList() {
        // Given
        let rates = scheduler.createObserver([CurrencyRate].self)

        sut.output.rates
            .drive(rates)
            .disposed(by: disposeBag)

        // when
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.reload)
            .disposed(by: disposeBag)

        scheduler.start()

        // then
        XCTAssertEqual(rates.events, [.next(10, [CurrencyRate]()), .completed(10)])
    }

    func test_WhenCalledRefreshWithCurrencies_ReturnsCurrenciesList() {

        // Given
        let rates = scheduler.createObserver([CurrencyRate].self)

        let currencyRate = CurrencyRate(iso: "USD", rate: 1.112)

        let latestRatesModel = LatestRatesModel(success: true,
                                                        timestamp: 1321312,
                                                        base: "EUR",
                                                        date: "23-05-14",
                                                        rates: [currencyRate.iso : currencyRate.rate])

        latestRatesService.latestRatesModel = latestRatesModel


        // bind the result
        sut.output.rates
            .drive(rates)
            .disposed(by: disposeBag)

        // When
        // mock a reload
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.input.reload)
            .disposed(by: disposeBag)

        scheduler.start()
        // Then
        XCTAssertEqual(rates.events, [.next(10, [currencyRate])])
    }

}

//MARK: Mock
fileprivate class LatestRatesServiceMock: LatestRatesService{
    
    
    var latestRatesModel: LatestRatesModel? = nil
    
    func getLatestRates() -> Single<LatestRatesModel> {
        
        if let latestRatesModel = latestRatesModel {
            //
            return .just(latestRatesModel)
            
        } else {
            
            return Single.error(ErrorResult.custom(string: "error"))
        }
    }
}

