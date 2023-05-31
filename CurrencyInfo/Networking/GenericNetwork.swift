//
//  Network.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//


import UIKit


struct GenericNetwork{
    
    static let shared = GenericNetwork()
    
    static let accessKey = "9717e66194da9954443497f08ac17ec5"
    static let baseUrl = "http://data.fixer.io/api"
    
    
    
    
    func performGet<T:Codable>(request: inout URLRequest,
                        _ type: T.Type,
                        completionHandler: @escaping ((Result<Data, ErrorResult>) -> Void)){
        
        if let reachability = Reachability(), !reachability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        
                
        URLSession.shared.dataTask(with: request) {
            
            data, response, error in
            
//            print(response)
            
            if let error = error {
                completionHandler(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }
            
            
            if let data = data {
                completionHandler(.success(data))
            }
        }.resume()
    }
}

