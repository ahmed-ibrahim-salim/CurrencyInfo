//
//  ConverterScreenVM.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class ConverterScreenViewModel {
    
    let latestRatesService: LatestRatesService
    let disposeBag = DisposeBag()

    // MARK: - Outputs
    let output: Output

    struct Output{
        let rates: Driver<[CurrencyRate]>
        // Loading
//        let isLoading: Driver<Bool>
        // Error
        let error: Driver<String>

    }
    
    // MARK: - Inputs
    let input: Input
    struct Input {
        let reload: PublishRelay<Void>
    }
//    private let viewDidRefreshSubject = PublishSubject<Void>()
    
    //MARK: Initialise
    init(
         _ latestRatesService: LatestRatesService
    ) {
        self.latestRatesService = latestRatesService
            
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let rates = reloadRelay
            .asObservable()
            .flatMapLatest({ latestRatesService.getLatestRates() })
            .map({
                LatestRatesModel in
                                
                var currenciesRates = [CurrencyRate]()

                for (key, value) in LatestRatesModel.rates{
                    let currenctRate = CurrencyRate(iso: key, rate: value)
                    currenciesRates.append(currenctRate)
                }

                print(currenciesRates)
                return currenciesRates
            })
            .asDriver { (error) -> Driver<[CurrencyRate]> in
                errorRelay.accept((error as? ErrorResult)?.localizedDescription ?? error.localizedDescription)
                return Driver.just([])
            }
        
        // 1)
        input = Input(reload: reloadRelay)
        
        output = Output(rates: rates,
                        error: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
    }
    
//    private func getConversionResult(from: Currency,
//                                 to: Currency,
//                                 amount: Double) throws -> Double?{
//        var result = 0.0
//
//        if let rateForFirstCurrency = rates[from.rawValue],
//            let rateForSecondCurrency = rates[from.rawValue]{
//
//              //  28.5       = 25     * 1.223
//            let amountInEuro = amount * rateForFirstCurrency
//
//            //    1500                 =  28.5        * 32.90
//            let amountInSecondCurrency = amountInEuro * rateForSecondCurrency
//
//            result = amountInSecondCurrency
//        }else{
//
//            guard let _ = rates[from.rawValue] else{
//                throw CurrencyRateError.firstCurrencyRateIsMissing
//            }
//
//            guard let _ = rates[to.rawValue] else{
//                throw CurrencyRateError.secondCurrencyRateIsMissing
//            }
//        }
//
//        return result
//    }
    
}


extension Observable where Element: Any {
    func startLoading(loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            loadingSubject.onNext(true)
        })
    }

    func stopLoading(loadingSubject: PublishSubject<Bool>) -> Observable<Element> {
        return self.do(onNext: { _ in
            loadingSubject.onNext(false)
        })
    }
}
