//
//  Parser.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

//class NetworkParser{
    
//    static func parseReturnedData<T:Codable>(data: Data,
//                                             _ type: T.Type) -> Observable<T>{
//        
//        do{
//            let model = try JSONDecoder().decode(type.self, from: data)
//            
//            print(model)
//            
//            return Observable.just(model)
//            
//        }catch{
//            
//            return Observable.error(ErrorResult.network(string: "Network error " + error.localizedDescription))
////            (nil, ErrorResult.network(string: "Network error " + error.localizedDescription))
//        }
//        
//        
//    }
    
    
    
//    static func parseReturnedDataaaa<T:Codable>(data: Data,
//                                             _ type: T.Type) throws -> T{
//
////        do{
//        try JSONDecoder().decode(type.self, from: data)
            
//            print(model)
//
//            return Observable.just(model)
//            throw ErrorResult.parser(string: "")
//
//
//        return model
        
        
//        }catch{
//
//            return Observable.error(ErrorResult.network(string: "Network error " + error.localizedDescription))
////            (nil, ErrorResult.network(string: "Network error " + error.localizedDescription))
//        }
        
        
//    }
//}
