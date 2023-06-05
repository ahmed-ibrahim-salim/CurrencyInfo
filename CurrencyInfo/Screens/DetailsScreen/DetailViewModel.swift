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
    
    let historicalDataLast3Days = PublishSubject<[HistoryDataItem]>()
    
    let errorMessage = PublishSubject<ErrorResult>()
    
    
    private let group = DispatchGroup()

    func getHistoricalDataLast3Days(_ historicalRequestData: HistoricalRequestData,
                                    completion: @escaping (Result<[HistoryDataItem], ErrorResult>) -> Void) {
        var collection = [HistoricalDataModel]()
        var historyDataItems = [HistoryDataItem]()
        var errors = [ErrorResult]()
        
        isLoading.onNext(true)

        let historicalDataForDay1 = getHistoricalDataWithDay(dayValue: -2, historicalRequestData)
        let historicalDataForDay2 = getHistoricalDataWithDay(dayValue: -1, historicalRequestData)
        let historicalDataForDay3 = getHistoricalDataWithDay(dayValue: 0, historicalRequestData)

        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay1) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                collection.append(historicalData)
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay2) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                collection.append(historicalData)
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.enter()
        getHistoricalDataForDay(historicalData: historicalDataForDay3) {[unowned self] result in
            switch result {
            case .success(let historicalData):
                collection.append(historicalData)
            case .failure(let error):
                errors.append(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            historyDataItems = collection.map {historicalDataModel in
//                date
//                [rate, rate]
                
                var currenciesRates = [CurrencyRate]()
                for (key, value) in historicalDataModel.rates {
                    let currenctRate = CurrencyRate(iso: key, rate: value)
                    currenciesRates.append(currenctRate)
                }
                
                let first = currenciesRates.first!
                let secod = currenciesRates[1]
                
                
                let historyDataItem = HistoryDataItem(date: historicalDataModel.date, toCurrencyRate: currenciesRates[0], fromCurrency: currenciesRates[1])
                
                return historyDataItem
            }.compactMap {$0}
            
            
            refresh()
           
        }
        
        func refresh() {
            isLoading.onNext(false)

            if !errors.isEmpty {
                errorMessage.onNext(errors[0])
                completion(.failure(errors[0]))
            } else {
                historicalDataLast3Days.onNext(historyDataItems)
                completion(.success(historyDataItems))
            }
        }

    }
    
    private func getHistoricalDataWithDay(dayValue: Int,
                                          _ historicalRequestData: HistoricalRequestData) -> HistoricalRequestData {
        
        var innerHistoricalRequestData = historicalRequestData
        innerHistoricalRequestData.date = getDate(value: dayValue)
        
        return innerHistoricalRequestData
    }
    
    func getHistoricalDataForDay(historicalData: HistoricalRequestData, completion: @escaping (Result<HistoricalDataModel, ErrorResult>) -> Void) {
        
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
    func getDate(value: Int) -> String {
        
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: value, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayDate = formatter.string(from: day!)
        print(dayDate)
        return dayDate
    }
}

struct HistoryDataItem{
    var date: String
    var toCurrencyRate: CurrencyRate
    var fromCurrency: CurrencyRate
}
