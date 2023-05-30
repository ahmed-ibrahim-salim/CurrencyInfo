//
//  ConverterScreenVM.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import Foundation



class ConverterScreenViewModel: NSObject {
    
    weak var controller: ConverterScreen!
        
    var availableCurrencies: [Currency] = []{
        didSet{
            if !availableCurrencies.isEmpty{
                print(availableCurrencies)
            }
        }
    }
    
    var rates: [Currency.RawValue : Double] = [:]{
        didSet{
            if !rates.isEmpty{
                print(rates)
            }
        }
    }

    init(controller: ConverterScreen!) {
        self.controller = controller
    }
    
    
    //MARK: Network
    func performLatestRatesRequest(){
        let latestRequest = LatestRequest.constructURl()

        Network.perform(url: latestRequest,
                        LatestModel.self){
            [weak self] result in
            
            guard let self = self else{return}
            
            switch result{
            case .success(let data):
                
                self.rates = data.rates
                break
                
            case .failure(let error):
                print(error)

            }
        }
    }
    
    func performGetAvailableCurrenciesRequest(){
        let availableCurrenciesRequest = AvailableCurrenciesRequest.constructURl()

        Network.perform(url: availableCurrenciesRequest,
                        AvailableCurrenciesModel.self){
            [weak self] result in
            
            guard let self = self else{return}
            
            switch result{
            case .success(let data):
                
                let curruncies: [Currency?] = data.symbols.map({
                    dictionaryItem in
                    
                    if let currency = Currency(rawValue: dictionaryItem.key){
                        return currency
                    }
                    return nil
                })
                
                self.availableCurrencies = curruncies.compactMap({$0})
                
                break
                
            case .failure(let error):
                print(error)

            }
        }
    }
    
    private func getConversionResult(from: Currency,
                                 to: Currency,
                                 amount: Double) throws -> Double?{
        var result = 0.0
        
        if let rateForFirstCurrency = rates[from.rawValue],
            let rateForSecondCurrency = rates[from.rawValue]{
            
              //  28.5       = 25     * 1.223
            let amountInEuro = amount * rateForFirstCurrency
                        
            //    1500                 =  28.5        * 32.90
            let amountInSecondCurrency = amountInEuro * rateForSecondCurrency
            
            result = amountInSecondCurrency
        }else{
            
            guard let _ = rates[from.rawValue] else{
                throw CurrencyRateError.firstCurrencyRateIsMissing
            }
            
            guard let _ = rates[to.rawValue] else{
                throw CurrencyRateError.secondCurrencyRateIsMissing
            }
        }
        
        return result
    }
    
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
