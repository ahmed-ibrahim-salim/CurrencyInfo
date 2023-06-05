//
//  HistoricalDataService.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation
import RxSwift

protocol HistoricalDataServiceProtocol {
    
    func getHistoricalData(_ historicalRequestData: HistoricalRequestData, completionHandler: @escaping (Result<HistoricalDataModel, ErrorResult>) -> Void)
    
}

class HistoricalDataService: HistoricalDataServiceProtocol {
    
    private var network = NetworkCaller.shared
    
    func getHistoricalData(_ historicalRequestData: HistoricalRequestData, completionHandler: @escaping (Result<HistoricalDataModel, ErrorResult>) -> Void) {
        
        let getHistoricalDataRequest = HistoricalDataRequest.constructURlRequest(historicalRequestData)
        
        
        network.performGet(url: getHistoricalDataRequest,
                           HistoricalDataModel.self) {result in
            
            switch result {
            case .success(let data):
                
                completionHandler(.success(data))
                
            case .failure(let error):
                completionHandler(.failure(ErrorResult.network(string: error.localizedDescription)))
                
            }
        }
    }

}

struct HistoricalDataRequest {

    static func constructURlRequest(_ historicalRequestData: HistoricalRequestData) -> URLRequest {
        // should be
        // {{base-url}}/2023-05-13?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        
        var url = URL(string: NetworkConstants.baseUrl)!

        url.append(path: historicalRequestData.date)

        let symbols = [historicalRequestData.fromCurrency.iso,
                       historicalRequestData.toCurrencyRate.iso].joined(separator: ",")

        let queryItems = [URLQueryItem(name: "access_key", value: NetworkConstants.accessKey),
                          URLQueryItem(name: "symbols", value: symbols)]

        url.append(queryItems: queryItems)

        print(url)
        return RequestFactory.request(method: .GET, url: url)

    }
    
}

struct HistoricalRequestData {
    var date: String
    let fromCurrency: CurrencyRate
    let toCurrencyRate: CurrencyRate
}
