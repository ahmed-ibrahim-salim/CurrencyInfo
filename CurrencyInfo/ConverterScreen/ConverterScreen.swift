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
    var availableCurrencies: [CurrencyRate] = []
    let disposeBag = DisposeBag()
    
        
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(didBecomeActiveThenRefresh),
//                                               name: UIApplication.didBecomeActiveNotification,
//                                               object: nil)
                
        let latestRatesService = LatestRates()

        
        viewModel = ConverterScreenViewModel(latestRatesService)
        
        bindViewModel()

    }


    @objc private func didBecomeActiveThenRefresh() {
        viewModel.input.reload.accept(())

    }
    
    //  MARK: ViewModel Binding
    private func bindViewModel() {
        
        // MARK: Inputs

        
        //MARK: outputs
        viewModel.output.rates.drive()
            .disposed(by: disposeBag)
        //            .drive(humidityLabel.rx.text)
        //            .disposed(by: disposeBag)
        
    }

    // for labels
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    
    
    
    @IBAction func toCurrencyAction(_ sender: Any) {
    }
    
    @IBAction func reverseAction(_ sender: Any) {
    }
    
    @IBAction func fromCurrencyAction(_ sender: Any) {
    }
    
    @IBAction func openDetailsAction(_ sender: Any) {
        
    }
}


