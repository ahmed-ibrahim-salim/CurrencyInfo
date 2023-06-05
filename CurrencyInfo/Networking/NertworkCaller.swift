//
//  NertworkCaller.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 04/06/2023.
//

import Foundation

struct NetworkCaller {
    
    static let shared = NetworkCaller()
    
    //    private func parseReturnedData<T: Codable>(data: Data, _ type: T.Type) throws -> T? {
    //
    //        do {
    //            let model = try JSONDecoder().decode(type.self, from: data)
    //
    //            return model
    //
    //        } catch {
    //            let decodedError = try JSONDecoder().decode(ErrorModel.self, from: data)
    //            throw ErrorResult.custom(string: decodedError.error.info)
    //
    //        }
    //
    //    }
    private func parseReturnedData<T: Codable>(data: Data, _ type: T.Type, completionHandler: @escaping ((Result<T, Error>) -> Void)) {
        
        do {
            let model = try JSONDecoder().decode(type.self, from: data)
            
            completionHandler(.success(model))
            
            print(model)
        } catch {
//            do {
//                let decodedError = try JSONDecoder().decode(ErrorModel.self, from: data)
//                completionHandler(.failure(ErrorResult.custom(string: decodedError.error.info)))
//            } catch {
//                
//            }
            completionHandler(.failure(error))
//            throw error
            
        }
    }
    
    func performGet<T: Codable>(url: URLRequest, _ type: T.Type, completionHandler: @escaping ((Result<T, Error>) -> Void)) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            //            print(response)
            
            if let data = data {
                
                // parsing
                self.parseReturnedData(data: data, type) {result in
                    
                    switch result {
                    case .success(let data):
                        
                        completionHandler(.success(data))
                        
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completionHandler(.failure(ErrorResult.custom(string: error.localizedDescription)))
                
            }
        }.resume()
    }
}
