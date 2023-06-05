//
//  ConvertionRequest.swift
//  CurrencyInfo
//
//  Created by Ahmed medo on 31/05/2023.
//

import Foundation
import RxSwift

protocol LatestRatesService {
    
    func getLatestRates() -> Single<LatestRatesModel>
}

class LatestRates: LatestRatesService {
    
    func getLatestRates() -> Single<LatestRatesModel> {
        
        let getLatestRates = URLSession.shared.rx
            .response(request: LatestRatesRequest.constructURlRequest())
            .asSingle()
            .catchNetworkRequestsErrors(LatestRatesModel.self)
        
        return getLatestRates
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == (response: HTTPURLResponse, data: Data) {
    
    func catchNetworkRequestsErrors<T: Codable>(_ type: T.Type) -> Single<T> {
        return flatMap { response, data in
            
            if 200..<300 ~= response.statusCode {
                do {
                    let decodedData = try JSONDecoder().decode(type.self, from: data)
                    
                    return .just(decodedData)
                } catch {
                    let decodedError = try JSONDecoder().decode(ErrorModel.self, from: data)
                    throw ErrorResult.custom(string: decodedError.error.info)
                }
                
            } else {
                throw ErrorResult.network(string: response.debugDescription)
            }
        }
    }
    
}

struct LatestRatesRequest {
    
    static func constructURlRequest() -> URLRequest {
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        var url = URL(string: NetworkConstants.baseUrl)!
        
        url.append(path: "latest")
                
        let queryItems = [URLQueryItem(name: "access_key", value: NetworkConstants.accessKey)]
        
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
