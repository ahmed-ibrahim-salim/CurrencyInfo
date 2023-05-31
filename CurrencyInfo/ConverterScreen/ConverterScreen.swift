//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import UIKit
import RxSwift

class ConverterScreen: UIViewController {
    
    
    var viewModel: ConverterScreenViewModel!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        instantiateViewModel()
        
        
    }
    private func instantiateViewModel(){
        
        let availableCurrenciesService = AvailableCurrencies()
        let LatestRatesService = LatestRates()
        
        
        
        viewModel = ConverterScreenViewModel(availableCurrenciesService: availableCurrenciesService,
                                             LatestRatesService: LatestRatesService)
        
        
        viewModel.controller = self
    }
    
    var availableCurrencies: [Currency] = []
    let disposeBag = DisposeBag()

    func setupBinding(){
        
        viewModel?.availableCurrencies
            .asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                [weak self] availableCurrencies in
                self?.availableCurrencies = availableCurrencies
//
                
                
//                self?.mainTableView.reloadData()
            }).disposed(by: disposeBag)
        
        
        viewModel?.isLoading
            .asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                [weak self] isLoading in
                if isLoading {
                    //                        self?.loadingAnimation.alpha = 1
                    //                        self?.loadingAnimation.play()
                } else {
                    //                        self?.loadingAnimation.alpha = 0
                    //                        self?.loadingAnimation.stop()
                    //                        // stop refresh control
                    //                        self?.mainTableView.refreshControl?.endRefreshing()
                    
                }
            }).disposed(by: disposeBag)
        
        viewModel?.error
            .asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] err in
                self?.showAlert(message: err.localizedDescription)
            }).disposed(by: disposeBag)
    }
}


