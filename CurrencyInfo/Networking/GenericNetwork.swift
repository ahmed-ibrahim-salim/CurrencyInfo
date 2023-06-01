//
//  Network.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//


import UIKit
import RxSwift


struct GenericNetwork{
    
    static let shared = GenericNetwork()
    
    static let accessKey = "9717e66194da9954443497f08ac17ec5"
    static let baseUrl = "http://data.fixer.io/api"
    
    
    
    
    func performGet<T:Codable>(request: URLRequest,
                               _ type: T.Type) -> Observable<(response: HTTPURLResponse, data: Data)>{
        

        
                
        return URLSession.shared.rx.response(request: request)
        
//        URLSession.shared.dataTask(with: request) {
//
//            data, response, error in
//
////            print(response)

//        }.resume()
    }
    
    static func handleNetworkErrors(response: HTTPURLResponse, data: Data) -> Observable<Data>{
        
        if 200..<300 ~= response.statusCode{
            return Observable.just(data)

        }else{
            return Observable.error(ErrorResult.network(string: response.debugDescription))
        }

        
    }
    static func handleNetworkErrorsWithSingle(response: HTTPURLResponse)->Single<Any>{
        
        
        return Single.create{
            single in
            
            if 200..<300 ~= response.statusCode{
                 single(.success(1))
//                Observable.just(data)

            }else{
                single(.failure(ErrorResult.network(string: response.debugDescription)))
//                Observable.error(ErrorResult.network(string: response.debugDescription))
            }
            
            return Disposables.create()
        }

    }
    
}

