//
//  AvailableCurrencies.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

protocol AvailableCurrenciesService{
        
//    func getAvailableCurrencies(completionHandler: @escaping (Result<AvailableCurrenciesModel, ErrorResult>)->Void)
    
//    func getAvailableCurrencies() -> Observable<T>
//    /Observable<AvailableCurrenciesModel>
    
    func getAvailableCurrencies(completion: @escaping (Result<Single<Any>,ErrorResult>)-> Void)
    
}


class AvailableCurrencies: AvailableCurrenciesService{
    
    private var network = GenericNetwork.shared
    
    func getAvailableCurrencies(completion: @escaping (Result<Single<Any>,ErrorResult>)-> Void){
        
        var availableCurrenciesRequest = AvailableCurrenciesRequest.constructURlRequest()
        
                 
        network.performGet(request: &availableCurrenciesRequest,
                           AvailableCurrenciesModel.self){
            result in
            
            switch result{
            case .success(let data):
                
                // Parsing
                let single = NetworkParser.parseReturnedData(data: data, AvailableCurrenciesModel.self)
                
                completion(.success(single))

                
            case .failure(let error):
                completion(.failure(.network(string: error.localizedDescription)))
                break
            }
        }
    }
}


struct AvailableCurrenciesRequest{
    
    static func constructURlRequest()->URLRequest{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5
        var url = URL(string: GenericNetwork.baseUrl)!
        
        url.append(path: "symbols")
                
        let queryItems = [URLQueryItem(name: "access_key", value: GenericNetwork.accessKey)]
        
        url.append(queryItems: queryItems)
        
        
        
        return RequestFactory.request(method: .GET, url: url)
    }
    
}



final class RequestFactory {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
