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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActiveThenRefresh),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
                
        let availableCurrenciesService = AvailableCurrencies()

        
        viewModel = ConverterScreenViewModel(availableCurrenciesService: availableCurrenciesService)
        
        bindViewModel()

    }


//  MARK: ViewModel Binding
    private let refreshSubject = PublishSubject<Void>()
    
   
    @objc private func didBecomeActiveThenRefresh() {
        refreshSubject.onNext(())
    }
     
    private func bindViewModel() {
        
        // MARK: Inputs
        refreshSubject
            .subscribe(viewModel.input.viewDidRefresh)
            .disposed(by: disposeBag)
        
        
        //MARK: outputs
        viewModel.output.availlableRates.drive()
            .disposed(by: disposeBag)
        //            .drive(humidityLabel.rx.text)
        //            .disposed(by: disposeBag)
        
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
}


