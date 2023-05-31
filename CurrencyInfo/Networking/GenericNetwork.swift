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
    
    
    private func parseReturnedData<T:Codable>(data: Data,
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
    
    func performGet<T:Codable>(request: inout URLRequest,
                        _ type: T.Type,
                        completionHandler: @escaping ((Result<T, ErrorResult>) -> Void)){
        
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
                
                // parsing
                self.parseReturnedData(data: data, type){
                    result in
                    
                    switch result{
                    case .success(let data):
                        
                        completionHandler(.success(data))

                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }

            }
        }.resume()
    }
}

enum NetworkLayerError{
    case DecodingError(Error)
}
