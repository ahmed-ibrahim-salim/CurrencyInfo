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

//protocol ConverterScreenViewModelOutput{
//    func updateView()
//}

class ConverterScreenViewModel {
    
    weak var controller: ConverterScreen?
        
    let disposeBag = DisposeBag()
//    private var rates: [Currency.RawValue : Double] = [:]{
//        didSet{
//            if !rates.isEmpty{
//                print(rates)
//            }
//        }
//    }

    private let availableCurrenciesService: AvailableCurrenciesService
    private let LatestRatesService: LatestRatesService

    
    
    init(
         availableCurrenciesService: AvailableCurrenciesService,
         LatestRatesService: LatestRatesService
    ) {
        self.LatestRatesService = LatestRatesService
        self.availableCurrenciesService = availableCurrenciesService
        
    
    }
    
    
    let isLoading = PublishSubject<Bool>()
        
    var availableCurrencies = PublishSubject<[Currency]>()
        
    let error = PublishSubject<Error>()
    
    
    //MARK: Network

    func getAvailableCurrencies(){

        isLoading.onNext(true)
        
        availableCurrenciesService.getAvailableCurrencies(){
            [weak self] result in
            guard let self = self else{return}
            
            switch result{
            case .success(let single):
                
                isLoading.onNext(false)
                
                single.subscribe(onSuccess: {
                    data in
                    
                    let curruncies: [Currency?] = data.symbols.map({
                        dictionaryItem in
                        
                        if let currency = Currency(rawValue: dictionaryItem.key){
                            return currency
                        }
                        return nil
                    })
                    
                    self.availableCurrencies.onNext(curruncies.compactMap({$0}))
                    
                    
                }, onFailure: {
                    error in
                    self.error.onNext(error)
                }).disposed(by: self.disposeBag)

            case .failure(let error):
                isLoading.onNext(false)
                self.error.onNext(error)
                print(error)
                
            }
        }
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

enum CurrencyRateError: Error{
    case firstCurrencyRateIsMissing
    case secondCurrencyRateIsMissing
}

extension CurrencyRateError: LocalizedError {
    public var errorDescription: String? {
        
        switch self {
        case .firstCurrencyRateIsMissing:
            return NSLocalizedString("first Currency Rate Is Missing from rates", comment: "My error")
        case .secondCurrencyRateIsMissing:
            return NSLocalizedString("second Currency Rate Is Missing from rates", comment: "My error")
        }
    }
    
    
}
