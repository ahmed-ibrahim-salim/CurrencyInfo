//
//  AvailableCurrencies.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

protocol AvailableCurrenciesService{
        
//    func getAvailableCurrencies(completion: @escaping (Result<Single<AvailableCurrenciesModel>,ErrorResult>)-> Void)
    func getAvailableCurrencies()->Observable<(AvailableCurrenciesModel?, ErrorResult?)>
}


class AvailableCurrencies: AvailableCurrenciesService{
    
    private var network = GenericNetwork.shared
    
    //completion: @escaping (Result<Observable<AvailableCurrenciesModel>,ErrorResult>)-> Void
    func getAvailableCurrencies()->Observable<(AvailableCurrenciesModel?, ErrorResult?)>{
        
        var result: Observable<(AvailableCurrenciesModel?, ErrorResult?)> = AvailableCurrenciesRequest.constructURlRequest()
            .map{$0}
            .flatMap{
                [weak self] request -> Observable<(response: HTTPURLResponse, data: Data)>  in
                
                return self!.network.performGet(request: request,
                                                AvailableCurrenciesModel.self)
            }
            .map{
                response, data -> (AvailableCurrenciesModel?, ErrorResult?) in
                
                if let networkError =  GenericNetwork.handleNetworkErrors(response: response){
                    
                    return (nil, networkError)
                }else{
                    let parsingResult = NetworkParser.parseReturnedData(data: data, AvailableCurrenciesModel.self)

                    return parsingResult
                    
                }
            }
        
        return result
         
        
        //
        //            if let error = error {
        //                completionHandler(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
        //                return
        //            }
        //
        //
        //            if let data = data {
        //                completionHandler(.success(data))
        //            }
        
        
//        {
//
//            result in
//
//            switch result{
//            case .success(let data):
//
//                // Parsing
//                let observable = NetworkParser.parseReturnedData(data: data, AvailableCurrenciesModel.self)
//
//                return observable
//
//            case .failure(let error):
//
//                return Observable.error(ErrorResult.network(string: error.localizedDescription))
//            }
//        }
    }
}


struct AvailableCurrenciesRequest{
    
    static func constructURlRequest()->Observable<URLRequest>{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5
        var url = URL(string: GenericNetwork.baseUrl)!
        
        url.append(path: "symbols")
                
        let queryItems = [URLQueryItem(name: "access_key", value: GenericNetwork.accessKey)]
        
        url.append(queryItems: queryItems)
        
        
        
        return Observable.of(RequestFactory.request(method: .GET, url: url))
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
