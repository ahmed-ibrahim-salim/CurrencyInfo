//
//  ConvertionRequest.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

protocol LatestRatesService{
    
//    func getLatestRates(completion: @escaping (Result<Single<AvailableCurrenciesModel>,ErrorResult>)-> Void)
}

class LatestRates: LatestRatesService{
    
    private var network = GenericNetwork.shared

    var latestRatesRequest = LatestRatesRequest.constructURlRequest()
    
//    func getLatestRates(completion: @escaping (Result<Single<AvailableCurrenciesModel>,ErrorResult>)-> Void){
//
//
//        network.performGet(request: latestRatesRequest,
//                           LatestRatesModel.self){
//             result in
//
//
//            switch result{
//            case .success(let data):
////
//                // Parsing
//                let single = NetworkParser.parseReturnedData(data: data, AvailableCurrenciesModel.self)
//
//                completion(.success(single))
//
//            case .failure(let error):
//                completion(.failure(.network(string: error.localizedDescription)))
//
//            }
//        }
//    }
}


struct LatestRatesRequest{
    
    static func constructURlRequest()->URLRequest{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        var url = URL(string: GenericNetwork.baseUrl)!
        
        url.append(path: "latest")
        
        let symbols: String = ["USD", "AED"].joined(separator: ", ")
        
        let queryItems = [URLQueryItem(name: "access_key", value: GenericNetwork.accessKey),
                          URLQueryItem(name: "symbols", value: symbols)]
        
        url.append(queryItems: queryItems)
        
        return RequestFactory.request(method: .GET, url: url)

    }
    
}
