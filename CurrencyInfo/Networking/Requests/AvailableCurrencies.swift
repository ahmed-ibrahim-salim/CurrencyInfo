//
//  AvailableCurrencies.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

protocol AvailableCurrenciesService{
    func getAvailableSymbols()->Single<AvailableCurrenciesModel>
}


class AvailableCurrencies: AvailableCurrenciesService{
    func getAvailableSymbols()->Single<AvailableCurrenciesModel>{
        
        let getAvailableSymbols = URLSession.shared.rx
            .response(request: AvailableCurrenciesRequest.constructURlRequestNoObser())
            .asSingle()
            .catchAvailableCurrenciesError(AvailableCurrenciesModel.self)
        
        return getAvailableSymbols
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data){
    
    func catchAvailableCurrenciesError(_ type: AvailableCurrenciesModel.Type) -> Single<AvailableCurrenciesModel> {
        return flatMap { response, data in

            if 200..<300 ~= response.statusCode{
                do{
                    let decodedData = try JSONDecoder().decode(type.self, from: data)

                    return .just(decodedData)
                }catch{
                    throw error
                }

            }else{
                throw ErrorResult.network(string: response.debugDescription)
            }
        }
    }

}

struct AvailableCurrenciesRequest{

    
    static func constructURlRequestNoObser()->URLRequest{
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
