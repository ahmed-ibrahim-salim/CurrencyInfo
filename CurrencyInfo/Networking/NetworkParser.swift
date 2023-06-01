//
//  Parser.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import Foundation
import RxSwift

class NetworkParser{
    
    static func parseReturnedData<T:Codable>(data: Data,
                                             _ type: T.Type) -> (T?, ErrorResult?){
        
        do{
            let model = try JSONDecoder().decode(type.self, from: data)
            
            print(model)
            
            return (model, nil)
            
        }catch{
            
            return (nil, ErrorResult.network(string: "Network error " + error.localizedDescription))
        }
        
        
    }
}
