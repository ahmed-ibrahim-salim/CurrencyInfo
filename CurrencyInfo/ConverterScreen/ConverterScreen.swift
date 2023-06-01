//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import UIKit
import RxSwift

class ConverterScreen: UIViewController {
    
    // MARK: Vars
    var viewModel: ConverterScreenViewModel!
    var availableCurrencies: [Currency] = []
    let disposeBag = DisposeBag()
    
    
    
    
    @IBOutlet weak var humidityLabel: UILabel!

    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        instantiateViewModel()
//        setupViewModelBinding()
        
        
        
//        viewModel.getAvailableCurrencies()
        
        bindViewModel()

    }
    private func instantiateViewModel(){
//
//        let availableCurrenciesService = AvailableCurrencies()
//        let LatestRatesService = LatestRates()
        
        
        
//        viewModel = ConverterScreenViewModel(availableCurrenciesService: availableCurrenciesService,
//                                             LatestRatesService: LatestRatesService)
        
        
//        viewModel.controller = self
        
//        viewModel = ConverterScreenViewModel()
        
    }
    

//  MARK: ViewModel Binding
    
    private func bindViewModel() {
        
        
        
        // MARK: Inputs

        
        
        //MARK: outputs
        viewModel.output.availlableRates.drive().disposed(by: disposeBag)
//            .drive(humidityLabel.rx.text)
//            .disposed(by: disposeBag)
    }

}


