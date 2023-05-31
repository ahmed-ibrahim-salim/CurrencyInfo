//
//  AvailableCurrencies.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation


protocol AvailableCurrenciesService{
        
    func getAvailableCurrencies(completionHandler: @escaping (Result<AvailableCurrenciesModel, Error>)->Void)
}

class AvailableCurrencies: AvailableCurrenciesService{
    
    private var network = GenericNetwork.shared
    
    func getAvailableCurrencies(completionHandler: @escaping (Result<AvailableCurrenciesModel, Error>)->Void){
        
        let availableCurrenciesRequest = AvailableCurrenciesRequest.constructURl()

        
        network.performGet(url: availableCurrenciesRequest,
                           AvailableCurrenciesModel.self){
            result in
                        
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


struct AvailableCurrenciesRequest{
    
    static func constructURl()->URL{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5
        var url = URL(string: GenericNetwork.baseUrl)!
        
        url.append(path: "symbols")
                
        let queryItems = [URLQueryItem(name: "access_key", value: GenericNetwork.accessKey)]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
}
