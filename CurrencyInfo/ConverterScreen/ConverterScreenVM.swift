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
    
    let availableCurrenciesService: AvailableCurrenciesService
//    private let LatestRatesService: LatestRatesService

    // MARK: - Outputs
    let disposeBag = DisposeBag()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<ErrorResult>()
    
    let output: Output
    private let ratesSubject = PublishSubject<[Currency]>()

    struct Output{
        let availlableRates: Driver<[Currency]>
        // Loading
        let isLoading: Driver<Bool>
        // Error
        let error: Driver<ErrorResult>

    }
    
    // MARK: - Inputs
    let input: Input
    struct Input {
        let viewDidRefresh: AnyObserver<Void>
    }
    private let viewDidRefreshSubject = PublishSubject<Void>()
    
    //MARK: Initialise
    init(
         availableCurrenciesService: AvailableCurrenciesService
//         LatestRatesService: LatestRatesService
    ) {
//        self.LatestRatesService = LatestRatesService
        self.availableCurrenciesService = availableCurrenciesService
        
        // 2) connect Driver with subject, and get required field
        let availableRates = ratesSubject.asDriver(onErrorJustReturn: [])
        
        // 3) assign output with ui driver, loading and error related to that ui item
        output = Output(availlableRates: availableRates,
                        isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
                        error: errorSubject
            .asDriver(onErrorJustReturn: ErrorResult.custom(string: "Unknown error")))
        
        
        
        // 1)
        input = Input(viewDidRefresh: viewDidRefreshSubject.asObserver())
        
        // 5) initial for view did refresh
        viewDidRefreshSubject
            .startLoading(loadingSubject: isLoadingSubject)
            .flatMap { availableCurrenciesService.getAvailableSymbols().asObservable().materialize() }

            .stopLoading(loadingSubject: isLoadingSubject)
            .subscribe(onNext: { [unowned self] materializedEvent in
                switch materializedEvent {
                case let .next(availableCurrenciesModel):
                    
                    let symbols = availableCurrenciesModel.symbols
                    
                    let availableCurrencies = self.getCurreciesFromSymbols(symbols: symbols)

                    print(availableCurrencies)
                    
                    self.ratesSubject.onNext(availableCurrencies)
                case let .error(error):
                    
                    print(error)
                    // changing to my custom error
                    let customError = ErrorResult.custom(string: error.localizedDescription)
                    self.errorSubject.onNext(customError)
                default: break
                }
            })
            .disposed(by: disposeBag)
        
//
    }

    
    
    //MARK: Network

    func getCurreciesFromSymbols(symbols: [Currency.RawValue : String])-> [Currency]{

        let curruncies: [Currency] = symbols.map({
            dictionaryItem in

            if let currency = Currency(rawValue: dictionaryItem.key){
                return currency
            }
            return nil
        }).compactMap({$0})

        return curruncies

    }
//
//    func getAvailableCurrencies(){
//
//
//        let errorRelay = PublishRelay<String>()
//        let reloadRelay = PublishRelay<Void>()
//        let loadingRelay = PublishRelay<Bool>()
//
//
//
//        let rates = reloadRelay
//            .asObservable()
//            .flatMapLatest({
//                [weak self] _ in self!.availableCurrenciesService.getAvailableCurrencies()
//
//            })
//            .map{
//               [weak self] data, error -> [Currency]? in
//
//                if error != nil{
//                    return nil
//                }else{
//                    guard let symbols = data?.symbols else{
//                        return nil
//                    }
//                    return self!.getCurreciesFromSymbols(symbols: symbols)
//                }
//
//            }
//            .asDriver {
//                (error) in
//
//                return Driver.just([])
//            }
//
//
//
////
////        availableCurrenciesService.getAvailableCurrencies(){
////            [weak self] result in
////            guard let self = self else{return}
////
////            switch result{
////            case .success(let single):
////
////                isLoading.onNext(false)
//
////                single.bind(to: <#T##PublishRelay<Element>...#>)
//
////                single.subscribe(onSuccess: {
////                    data in
////
////                    let curruncies: [Currency?] = data.symbols.map({
////                        dictionaryItem in
////
////                        if let currency = Currency(rawValue: dictionaryItem.key){
////                            return currency
////                        }
////                        return nil
////                    })
////
////                    self.availableCurrencies.onNext(curruncies.compactMap({$0}))
////
////
////                }, onFailure: {
////                    error in
////                    self.error.onNext(error)
////                }).disposed(by: self.disposeBag)
//
////            case .failure(let error):
////                isLoading.onNext(false)
////                self.error.onNext(error)
////                print(error)
////
////            }
////        }
//    }
    
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
