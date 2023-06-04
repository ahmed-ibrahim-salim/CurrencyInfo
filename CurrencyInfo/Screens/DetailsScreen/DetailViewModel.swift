//
//  DetailViewModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation
import RxSwift

class DetailViewModel: NSObject{
    
    let historicalDataService: HistoricalDataService
    
    init(historicalDataService: HistoricalDataService) {
        self.historicalDataService = historicalDataService
    }
    
    let isLoading = PublishSubject<Bool>()
    
    let historicalData = PublishSubject<HistoricalDataModel>()
    
    let error = PublishSubject<Error>()
    
    
    private var historicalDataHolder: HistoricalDataModel?{
        didSet{
            if let historicalData = historicalDataHolder, historicalData.rates.count > 2{
                
                let rates = historicalData.rates.map({CurrencyRate(iso: $0.key, rate: $0.value)})
                
                // refresh tableview
                self.historicalData.onNext(historicalData)
                
                print(rates)
            }
        }
        
    }


    func getHistoricalDataForPast3Days(){
        
        isLoading.onNext(true)
        
        let historicalData = HistoricalRequestData(date: getDate(value: -1),
                                                   fromCurrency: CurrencyRate(iso: "USD", rate: 1.3),
                                                   toCurrencyRate: CurrencyRate(iso: "AED", rate: 2.5))
        
        historicalDataService.getHistoricalData(historicalData){
            [unowned self] result in
            
            switch result{
            case .success(let historicalData):
                
                print(historicalData)
                self.isLoading.onNext(false)

                
            case .failure(let error):
                
                self.isLoading.onNext(false)
                
                self.error.onNext(error)
                print(error)
                
            }
        }
    }
    private func getDate(value: Int)->String{
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: value, to: Date())
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayDate = formatter.string(from: day!)
        print(dayDate)
        return dayDate
    }
}
