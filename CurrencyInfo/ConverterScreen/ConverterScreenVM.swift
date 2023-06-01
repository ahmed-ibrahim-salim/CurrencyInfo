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
    
    
        
    
    struct Output{
        let availableCurrencies: Driver<[Currency]>
        let errorMessage: Driver<String>
        let isLoading: Driver<Bool>

    }
    
    struct Input{
        let reload: PublishRelay<Void>
    }
    
    
    //MARK: Network

    func getAvailableCurrencies(){

        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        let loadingRelay = PublishRelay<Bool>()

        
        
        let rates = availableCurrenciesService.getAvailableCurrencies().compactMap({
            data, error in
            
            data
        })
//            .filter({ data, error in
//                let error
//                return true
//            })
//            .map{ $0.rates }
//            .asDriver { (error) -> Driver<[CurrencyRate]> in
//                errorRelay.accept((error as? ErrorResult)?.localizedDescription ?? error.localizedDescription)
//                return Driver.just([])
//            }
//            .subscribe(
//            onNext: { result, error in
//
//                if let error = error{
//
//                }
//
//            }
//        ).disposed(by: disposeBag)
//
//        availableCurrenciesService.getAvailableCurrencies(){
//            [weak self] result in
//            guard let self = self else{return}
//
//            switch result{
//            case .success(let single):
//
//                isLoading.onNext(false)
                
//                single.bind(to: <#T##PublishRelay<Element>...#>)
                
//                single.subscribe(onSuccess: {
//                    data in
//
//                    let curruncies: [Currency?] = data.symbols.map({
//                        dictionaryItem in
//
//                        if let currency = Currency(rawValue: dictionaryItem.key){
//                            return currency
//                        }
//                        return nil
//                    })
//
//                    self.availableCurrencies.onNext(curruncies.compactMap({$0}))
//
//
//                }, onFailure: {
//                    error in
//                    self.error.onNext(error)
//                }).disposed(by: self.disposeBag)

//            case .failure(let error):
//                isLoading.onNext(false)
//                self.error.onNext(error)
//                print(error)
//
//            }
//        }
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
