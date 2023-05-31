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
                                      _ type: T.Type) -> Single<T>{
        return Single.create{
            
            single in
            
            do{
                let model = try JSONDecoder().decode(type.self, from: data)

                single(.success(model))
                print(model)
            }catch{

                single(.failure(ErrorResult.network(string: "Network error " + error.localizedDescription)))

            }
            
            return Disposables.create()
            
            
            
        }

        
    }
}
