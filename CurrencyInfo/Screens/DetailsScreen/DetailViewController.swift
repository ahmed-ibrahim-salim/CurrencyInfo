//
//  DetailViewController.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 04/06/2023.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController, DetailViewControllerProtocol {

    var viewModel: DetailViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let historicalDataService = HistoricalDataService()
        
        viewModel = DetailViewModel(historicalDataService: historicalDataService)

        setupTableViewDataSources()
        
        bindViewModel()
        
        callApi()
        
        
                
    }
    
    var historicalDataTableDataSource: HistoricalDataTableDataSource!
    var historicalData: [HistoryDataItem] = [] {
        didSet {
            historicalTableView.reloadData()
        }
    }
    
    func setupTableViewDataSources() {
        historicalDataTableDataSource = HistoricalDataTableDataSource()
        historicalDataTableDataSource!.detailsScreen = self
        
        historicalTableView.delegate = historicalDataTableDataSource
        historicalTableView.dataSource = historicalDataTableDataSource
        
//        otherCurrenciesTableView.delegate = tablesDataSource
//        otherCurrenciesTableView.dataSource = tablesDataSource
        
    }
    
    
    
    
    
    var fromCurrency: CurrencyRate!
    var toCurrency: CurrencyRate!
    
    func callApi() {
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
                self.historicalData = currencyRates
//                print(currencyRates)
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


protocol DetailViewControllerProtocol: AnyObject {
    var historicalData: [HistoryDataItem] {get}
    var fromCurrency: CurrencyRate! {get}
    var toCurrency: CurrencyRate! {get}
    
}

class HistoricalDataTableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var detailsScreen: DetailViewControllerProtocol!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsScreen.historicalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        
        if 0..<detailsScreen.historicalData.count ~= indexPath.row {
            
            let fromCurrncyIso = detailsScreen.historicalData[indexPath.row].fromCurrency.iso
            let toCurrncyIso = detailsScreen.historicalData[indexPath.row].toCurrencyRate.iso
            
            let fromRate = detailsScreen.historicalData[indexPath.row].fromCurrency.rate
            let toRate = detailsScreen.historicalData[indexPath.row].toCurrencyRate.rate
            
            let roundedFro = round(num: fromRate)
            let roundedto = round(num: toRate)
            
            cell.textLabel?.text = "\(fromCurrncyIso): \(roundedFro) \(toCurrncyIso): \(roundedto)"

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func round(num: Double) -> Decimal {
        
        var fromRate = Decimal(num)
        var roundedResult = Decimal()
        NSDecimalRound(&roundedResult, &fromRate, 2, .bankers)
        
        return roundedResult
    }
}
