//
//  DetailViewModel.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation
import RxSwift

class DetailViewModel: NSObject {
    
    let historicalDataService: HistoricalDataServiceProtocol
    
    init(historicalDataService: HistoricalDataServiceProtocol) {
        self.historicalDataService = historicalDataService
    }
    
    let isLoading = PublishSubject<Bool>()
    
    let historicalDataLast3Days = PublishSubject<[CurrencyRate]>()
    
    let errorMessage = PublishSubject<ErrorResult>()
    
    
    let group = DispatchGroup()
    
    var collection = [HistoricalDataModel]()
    var errors = [ErrorResult]()
    

    func getHistoricalDataLast3Days() {
        isLoading.onNext(true)

        let historicalDataForDay1 = getHistoricalDataWithDay(dayValue: -2)
        let historicalDataForDay2 = getHistoricalDataWithDay(dayValue: -1)
        let historicalDataForDay3 = getHistoricalDataWithDay(dayValue: 0)

        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay1) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                
                self.collection.append(historicalData)
                
            case .failure(let error):
                errors.append(error)
            }
            
            group.leave()
        }
        
        
        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay2) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                
                self.collection.append(historicalData)
                
            case .failure(let error):
                errors.append(error)
            }
            
            group.leave()
        }
        
        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay3) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                
                self.collection.append(historicalData)
                
            case .failure(let error):
                errors.append(error)
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {[unowned self] in
            
            let rates: [CurrencyRate] = self.collection.map {historicalDataModel in
                guard let rate = historicalDataModel.rates.first else {return nil}
                return CurrencyRate(iso: rate.key, rate: rate.value)
            }.compactMap {$0}
            
            self.historicalDataLast3Days.onNext(rates)
        }
        
        isLoading.onNext(false)

    }
    
    private func getHistoricalDataWithDay(dayValue: Int) -> HistoricalRequestData {
        return HistoricalRequestData(date: getDate(value: dayValue),
                                     fromCurrency: CurrencyRate(iso: "USD", rate: 1.3),
                                     toCurrencyRate: CurrencyRate(iso: "AED", rate: 2.5))
    }
    
    private func getHistoricalDataForDay(historicalData: HistoricalRequestData, completion: @escaping (Result<HistoricalDataModel, ErrorResult>) -> Void) {
        
        historicalDataService.getHistoricalData(historicalData) {result in
            
            switch result {
            case .success(let historicalData):
                completion(.success(historicalData))
                
            case .failure(let error):
                
                completion(.failure(error))

                print(error)
                
            }
        }
    }
    private func getDate(value: Int) -> String {
        
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: value, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayDate = formatter.string(from: day!)
        print(dayDate)
        return dayDate
    }
}
