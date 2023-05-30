//
//  Network.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//


import UIKit

class Network{
    
    static let accessKey = "9717e66194da9954443497f08ac17ec5"
    static let baseUrl = "http://data.fixer.io/api"
    
    
    static private func parseReturnedData<T:Codable>(data: Data,
                                                     _ type: T.Type,
                                                     completionHandler: @escaping ((Result<T, Error>) -> Void)){
        
        do{
            let latestModel = try JSONDecoder().decode(type.self, from: data)
            
            completionHandler(.success(latestModel))
            
            print(latestModel)
        }catch{
            completionHandler(.failure(error))
            print(NetworkLayerError.DecodingError(error))
        }
    }
    
    static func perform<T:Codable>(url: URL,
                        _ type: T.Type,
                        completionHandler: @escaping ((Result<T, Error>) -> Void)){
                
        let task = URLSession.shared.dataTask(with: url) {
            
            data, response, error in
            
//            print(response)
            
            if let data = data {
                
                // parsing
                parseReturnedData(data: data, type){
                    result in
                    
                    switch result{
                    case .success(let data):
                        
                        completionHandler(.success(data))

                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }

            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }
}

enum NetworkLayerError{
    case DecodingError(Error)
}
