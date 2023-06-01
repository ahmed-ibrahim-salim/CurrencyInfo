////
////  CurrencyInfoTests.swift
////  CurrencyInfoTests
////
////  Created by magdy khalifa on 31/05/2023.
////
//
//import XCTest
//import RxTest
//import RxSwift
//
//@testable import CurrencyInfo
//
//final class CurrencyInfoTests: XCTestCase {
//
//    private var sut: ConverterScreenViewModel!
//    private var availableCurrencies: AvailableCurrenciesServiceMock!
//    private var latestRatesService: LatestRatesServiceMock!
//
//    private var scheduler: TestScheduler!
//    private var disposeBag: DisposeBag!
//
//
//    override func setUpWithError() throws {
//
//        scheduler = TestScheduler(initialClock: 0)
//        disposeBag = DisposeBag()
//
//        availableCurrencies = AvailableCurrenciesServiceMock()
//        latestRatesService = LatestRatesServiceMock()
//
//        sut = ConverterScreenViewModel(availableCurrenciesService: availableCurrencies,
//                                       LatestRatesService: latestRatesService)
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//        availableCurrencies = nil
//        latestRatesService = nil
//    }
//
//    func test_WhenCalledAvailableCurrenciesService_PushesOnNextEvent(){
//        // Given
//        
//        
//        let availableCurrenciesModel = scheduler.createObserver(AvailableCurrenciesModel.self)
//
//        
//        let singleOfAvailableCurrenciesModel = Single.create{
//            single in
//
//            let availableCurrenciesModel = AvailableCurrenciesModel(success: true,
//                                                                    symbols: ["USD" : "United States Dollar"])
//            single(.success(availableCurrenciesModel))
//
//            return Disposables.create()
//        }
//
//
//
//        availableCurrencies.getAvailableCurrenciesMockResult = .success(singleOfAvailableCurrenciesModel)
//
//
//
//        
//        // When
//        let aa = availableCurrencies.getAvailableCurrenciesMockResult
//        
//        
//        
////        sut.getAvailableCurrencies()
//
//        // Then
//
//
//
//
////        XCTAssertEqual([Recorded<Event<Equatable?>>], <#T##rhs: [Recorded<Event<Equatable?>>]##[Recorded<Event<Equatable?>>]#>)
//    }
//
//
////    func test_WhenCalledlatestRatesService_PushesOnNextEvent(){
////        // Given
////        let latestRatesModel = LatestRatesModel(success: true,
////                                                timestamp: 2,
////                                                base: "EUR",
////                                                date: "",
////                                                rates: ["USD" : 1.113])
////
////
////        // When
////
////
////        // Then
////    }
//}
//
//class AvailableCurrenciesServiceMock: AvailableCurrenciesService{
//
//    var getAvailableCurrenciesMockResult: Result<Single<AvailableCurrenciesModel>, ErrorResult>?
//
//    func getAvailableCurrencies(completion: @escaping (Result<Single<AvailableCurrenciesModel>, ErrorResult>) -> Void) {
//
//        if let result = getAvailableCurrenciesMockResult{
//            completion(result)
//        }
//    }
//}
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
//
