//
//  Requests.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import Foundation

protocol Request{
    static func constructURl()->URL
}

struct LatestRequest: Request{
    
    static func constructURl()->URL{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        var url = URL(string: Network.baseUrl)!
        
        url.append(path: "latest")
        
        let symbols: String = ["USD", "AED"].joined(separator: ", ")
        
        let queryItems = [URLQueryItem(name: "access_key", value: Network.accessKey),
                          URLQueryItem(name: "symbols", value: symbols)]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
}


struct AvailableCurrenciesRequest: Request{
    
    static func constructURl()->URL{
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5
        var url = URL(string: Network.baseUrl)!
        
        url.append(path: "symbols")
                
        let queryItems = [URLQueryItem(name: "access_key", value: Network.accessKey)]
        
        url.append(queryItems: queryItems)
        
        return url
    }
    
}
