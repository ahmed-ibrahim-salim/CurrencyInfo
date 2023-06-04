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
        let fromBtnName: Driver<CurrencyRate>
        let toBtnName: Driver<CurrencyRate>

        let from_TextFieldChanged: Driver<Decimal>
        let to_TextFieldChanged: Driver<Decimal>
        
        // Loading
//        let isLoading: Driver<Bool>
        // Error
        let error: Driver<String>

    }
    
    // MARK: - Inputs
    let input: Input
    struct Input {
        let reload: PublishRelay<Void>
        
        let changeFromBtnName: PublishSubject<CurrencyRate>

        let changeToBtnName: PublishSubject<CurrencyRate>
        
        let from_TextFieldChanged: PublishSubject<Decimal>
        
        let to_TextFieldChanged: PublishSubject<Decimal>
        
//        let
    }
//    private let viewDidRefreshSubject = PublishSubject<Void>()
    
    //MARK: Initializer
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
                        
//                self.baseCurrency =
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
        
        
        changeFromBtnName = PublishSubject<CurrencyRate>()
        changeToBtnName = PublishSubject<CurrencyRate>()
        from_TextFieldChanged = PublishSubject<Decimal>()
        
        to_TextFieldChanged = PublishSubject<Decimal>()

        let fromBtnName = changeFromBtnName
            .asDriver(onErrorJustReturn: CurrencyRate(iso: "From", rate: 0.0))
        
        let toBtnName = changeToBtnName
            .asDriver(onErrorJustReturn: CurrencyRate(iso: "From", rate: 0.0))
        
        
        let from_TextFieldChangedDriver = from_TextFieldChanged
            .asDriver(onErrorJustReturn: 1.0)
        
        let to_TextFieldChangedDriver = to_TextFieldChanged
            .asDriver(onErrorJustReturn: 1.0)
        
        // 1)
        input = Input(reload: reloadRelay,
                      changeFromBtnName: changeFromBtnName,
                      changeToBtnName: changeToBtnName,
                      from_TextFieldChanged: from_TextFieldChanged, to_TextFieldChanged: to_TextFieldChanged)
        
        output = Output(rates: rates,
                        fromBtnName: fromBtnName,
                        toBtnName: toBtnName,
                        from_TextFieldChanged: from_TextFieldChangedDriver,
                        to_TextFieldChanged: to_TextFieldChangedDriver,
                        error: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
    }
    
    let changeFromBtnName: PublishSubject<CurrencyRate>
    let changeToBtnName: PublishSubject<CurrencyRate>
    
    let from_TextFieldChanged: PublishSubject<Decimal>
    let to_TextFieldChanged: PublishSubject<Decimal>
    
    let baseCurrency = CurrencyRate(iso: "EUR", rate: 1.0)

    
    func getCurrencyBy(entry: String?,
                       fromRate: Double,
                       toRate: Double)->Decimal{

        if let string = entry,
           let decimal = Decimal(string: string){
            
            let fromRate = Decimal(fromRate)
            let toRate = Decimal(toRate)
            
            var result = (decimal / fromRate) * toRate
            
            var roundedResult = Decimal()
            NSDecimalRound(&roundedResult, &result, 2, .bankers)
            
            return roundedResult
            //        200 / 3.2 = 62.5
            //        62.5 * 1.5 = 93.75
            
        }else{
            return Decimal()
        }
        
        
    }

    
}

