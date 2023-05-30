//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import UIKit

class ConverterScreen: UIViewController {

    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        performLatestRatesRequest()

    }

    
    func performLatestRatesRequest(){
        let latestRequest = LatestRequest.constructURl()

        Network.perform(url: latestRequest,
                        LatestModel.self){
            result in
            
            switch result{
            case .success(let data):
                
                print(data)
                
            case .failure(let error):
                print(error)

            }
        }
    }

}

