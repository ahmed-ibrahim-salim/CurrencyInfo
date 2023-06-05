//
//  DetailViewController.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 04/06/2023.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    var viewModel: DetailViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let historicalDataService = HistoricalDataService()
        
        viewModel = DetailViewModel(historicalDataService: historicalDataService)

        bindViewModel()
        
        callApi()
        
        
                
    }
    var fromCurrency: CurrencyRate!
    var toCurrency: CurrencyRate!
    
    func callApi() {
//        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {return}
        
        let historicalData = HistoricalRequestData(date: viewModel.getDate(value: -1),
                                        fromCurrency: fromCurrency,
                                        toCurrencyRate: toCurrency)
        
        viewModel.getHistoricalDataLast3Days(historicalData) {_ in}
    }
    
    func bindViewModel() {
        
        viewModel.errorMessage
            .asDriver(onErrorJustReturn: ErrorResult.custom(string: "unknown error"))
            .drive(onNext: { [unowned self] errorMessage in
                self.showAlert(message: errorMessage.localizedDescription)
            }).disposed(by: disposeBag)
        
        
        viewModel.historicalDataLast3Days
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [unowned self] currencyRates in
                print(currencyRates)
            }).disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] isLoading in
                print(isLoading, "is loading")
            }).disposed(by: disposeBag)
        
    }

    let disposeBag = DisposeBag()
    @IBOutlet weak var otherCurrenciesTableView: UITableView!
    
    @IBOutlet weak var historicalTableView: UITableView!
    @IBOutlet weak var charView: UIView!
}
