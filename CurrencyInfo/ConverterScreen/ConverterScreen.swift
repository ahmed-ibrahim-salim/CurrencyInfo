//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import UIKit

class ConverterScreen: UIViewController {

    
    var viewModel: ConverterScreenViewModel!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        viewModel = ConverterScreenViewModel(controller: self)
        
//        viewModel.performLatestRatesRequest()
        viewModel.performGetAvailableCurrenciesRequest()

    }

    

}

