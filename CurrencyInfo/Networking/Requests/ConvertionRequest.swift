//
//  ConvertionRequest.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation


protocol LatestRatesService{
        
    func getLatestRates(completionHandler: @escaping (Result<LatestRatesModel, Error>)->Void)
}

class LatestRates: LatestRatesService{
    
    private var network = GenericNetwork.shared

    let latestRatesRequest = LatestRatesRequest.constructURl()
    
    func getLatestRates(completionHandler: @escaping (Result<LatestRatesModel, Error>)->Void){
        
                
        network.performGet(url: latestRatesRequest,
                           LatestRatesModel.self){
            [weak self] result in
            
            guard let self = self else{return}
            
            switch result{
            case .success(let data):
                
                
                completionHandler(.success(data))
                break
                
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
}


struct LatestRatesRequest{
    
    static func constructURl()->URL{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        var url = URL(string: GenericNetwork.baseUrl)!
        
        url.append(path: "latest")
        
        let symbols: String = ["USD", "AED"].joined(separator: ", ")
        
        let queryItems = [URLQueryItem(name: "access_key", value: GenericNetwork.accessKey),
                          URLQueryItem(name: "symbols", value: symbols)]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
}
