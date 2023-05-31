//
//  ConvertionRequest.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation


protocol LatestRatesService{
        
    func getLatestRates(completionHandler: @escaping (Result<LatestRatesModel, ErrorResult>)->Void)
}

class LatestRates: LatestRatesService{
    
    private var network = GenericNetwork.shared

    var latestRatesRequest = LatestRatesRequest.constructURlRequest()
    
    func getLatestRates(completionHandler: @escaping (Result<LatestRatesModel, ErrorResult>)->Void){
        
                
        network.performGet(request: &latestRatesRequest,
                           LatestRatesModel.self){
             result in
            
            
            switch result{
            case .success(let data):
                break
//                NetworkParser.parseReturnedData(data: data, LatestRatesModel.self){
//                    result in
//                    switch result{
//                    case .success(let data):
//
//                        completionHandler(.success(data))
//
//                        break
//
//                    case .failure(let error):
//                        completionHandler(.failure(.parser(string: "Error while parsing json data \(error.localizedDescription)")))
//
//                        break
//                    }
//                }
                
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
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
