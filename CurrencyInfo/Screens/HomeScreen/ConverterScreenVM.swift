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
    weak var controller: ConverterScreen!
    
    let latestRatesService: LatestRatesService
    let disposeBag = DisposeBag()

    // MARK: - Outputs
    let output: Output

    struct Output {
        let rates: Driver<[CurrencyRate]>
        let fromBtnName: Driver<CurrencyRate>
        let toBtnName: Driver<CurrencyRate>

        let fromTextFieldChanged: Driver<Decimal>
        let toTextFieldChanged: Driver<Decimal>
        
        let error: Driver<String>

    }
    
    // MARK: - Inputs
    let input: Input
    struct Input {
        let reload: PublishRelay<Void>
        
        let changeFromBtnName: PublishSubject<CurrencyRate>

        let changeToBtnName: PublishSubject<CurrencyRate>
        
        let fromTextFieldChanged: PublishSubject<Decimal>
        
        let toTextFieldChanged: PublishSubject<Decimal>
        
    }
    
    // MARK: Initializer
    init(
         _ latestRatesService: LatestRatesService
    ) {
        self.latestRatesService = latestRatesService
            
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let rates = reloadRelay
            .asObservable()
            .flatMapLatest({ latestRatesService.getLatestRates() })
            .map({ latestRatesModel in
                        
//                self.baseCurrency =
                var currenciesRates = [CurrencyRate]()

                for (key, value) in latestRatesModel.rates {
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
        fromTextFieldChanged = PublishSubject<Decimal>()
        
        toTextFieldChanged = PublishSubject<Decimal>()

        let fromBtnName = changeFromBtnName
            .asDriver(onErrorJustReturn: CurrencyRate(iso: "From", rate: 0.0))
        
        let toBtnName = changeToBtnName
            .asDriver(onErrorJustReturn: CurrencyRate(iso: "From", rate: 0.0))
        
        
        let fromTextFieldChangedDriver = fromTextFieldChanged
            .asDriver(onErrorJustReturn: 1.0)
        
        let toTextFieldChangedDriver = toTextFieldChanged
            .asDriver(onErrorJustReturn: 1.0)
        
        // 1)
        input = Input(reload: reloadRelay,
                      changeFromBtnName: changeFromBtnName,
                      changeToBtnName: changeToBtnName,
                      fromTextFieldChanged: fromTextFieldChanged, toTextFieldChanged: toTextFieldChanged)
        
        output = Output(rates: rates,
                        fromBtnName: fromBtnName,
                        toBtnName: toBtnName,
                        fromTextFieldChanged: fromTextFieldChangedDriver,
                        toTextFieldChanged: toTextFieldChangedDriver,
                        error: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
        
    }
    
    let changeFromBtnName: PublishSubject<CurrencyRate>
    let changeToBtnName: PublishSubject<CurrencyRate>
    
    let fromTextFieldChanged: PublishSubject<Decimal>
    let toTextFieldChanged: PublishSubject<Decimal>
    
    let baseCurrency = CurrencyRate(iso: "EUR", rate: 1.0)

    // MARK: Helpers
    
    func getCurrencyBy(entry: String?,
                       fromRate: Double,
                       toRate: Double) -> Decimal {

        if let string = entry,
           let decimal = Decimal(string: string) {
            
            let fromRate = Decimal(fromRate)
            let toRate = Decimal(toRate)
            
            var result = (decimal / fromRate) * toRate
            
            var roundedResult = Decimal()
            NSDecimalRound(&roundedResult, &result, 2, .bankers)
            
            return roundedResult
            //        200 / 3.2 = 62.5
            //        62.5 * 1.5 = 93.75
            
        } else { return Decimal() }
        
        
    }

    func getDecimalRatesFrom(_ fromRate: CurrencyRate,
                             currencyList: [CurrencyRate]) -> [DecimalResult] {
        
        let decimalResults = currencyList.map {[unowned self, fromRate] currencyRate in
            
            let resultValue = getCurrencyBy(entry: "1",
                                                      fromRate: fromRate.rate, toRate: currencyRate.rate)
            
            return DecimalResult(orginalISO: currencyRate.iso, result: resultValue)
        }
        
        return decimalResults
    }
    func shouldNavigateToDetailsScreen(fromRate: CurrencyRate,
                                       toRate: CurrencyRate,
                                       detailsVc: DetailViewController, currencyList: [CurrencyRate]) -> Bool {
        guard fromRate.iso != "From" && toRate.iso != "To" else {
            controller.showAlert(message: "Please choose currencies to see details")
            return false
        }
        guard fromRate.iso != toRate.iso else {
            controller.showAlert(message: "Please choose different currencies to see details")
            return false
        }
        
        detailsVc.fromCurrency = fromRate
        detailsVc.toCurrency = toRate
        
        detailsVc.decimalRatesFrom = getDecimalRatesFrom(fromRate, currencyList: currencyList)
        
        return true
    }
}
