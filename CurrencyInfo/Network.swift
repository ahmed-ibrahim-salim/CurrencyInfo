//
//  Network.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//


import UIKit


class Network{
    
    static let accessKey = "9717e66194da9954443497f08ac17ec5"
    static let baseUrl = "http://data.fixer.io/api"
    
    static func perform(){
        
        // should be
        // {{base-url}}/latest?access_key=9717e66194da9954443497f08ac17ec5&symbols=USD,AED
        var url = URL(string: Network.baseUrl)!
        
        url.append(path: "latest")
        
        let symbols: String = ["USD", "AED"].joined(separator: ", ")
                
        let queryItems = [URLQueryItem(name: "access_key", value: Network.accessKey),
                          URLQueryItem(name: "symbols", value: symbols)]

        url.append(queryItems: queryItems)
                
    
        
        let task = URLSession.shared.dataTask(with: url) {
            
            data, response, error in
            
            if let data = data {
                print(data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }
}
