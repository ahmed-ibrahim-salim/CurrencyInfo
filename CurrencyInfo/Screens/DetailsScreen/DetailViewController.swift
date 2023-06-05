//
//  DetailViewController.swift
//  CurrencyInfo
//
//  Created by Ahmed medo on 04/06/2023.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController, DetailViewControllerProtocol {

    var viewModel: DetailViewModel!

    let activityIndicator = UIActivityIndicatorView(style: .large)
    let indicatorView = UIView(frame: UIScreen.main.bounds)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let historicalDataService = HistoricalDataService()
        
        viewModel = DetailViewModel(historicalDataService: historicalDataService)

        setupTableViewDataSources()
        
        bindViewModel()
        
        callApi()
        
        fromCurrencyLbl.text = "From \(fromCurrency.iso)"
        
                
    }
    
    var historicalDataTableDataSource: HistoricalDataTableDataSource!
    var historicalData: [HistoryDataItem] = [] {
        didSet {
            historicalTableView.reloadData()
        }
    }
    
    var decimalRatesFrom = [DecimalResult]() {
        didSet {
            if let otherCurrenciesTableView = otherCurrenciesTableView {
                otherCurrenciesTableView.reloadData()
            }

        }
    }
    
    var otherCurrenciesTableDataSource: OtherCurrenciesTableDataSource!
    
    func setupTableViewDataSources() {
        historicalDataTableDataSource = HistoricalDataTableDataSource()
        historicalDataTableDataSource!.detailsScreen = self
        
        otherCurrenciesTableDataSource = OtherCurrenciesTableDataSource()
        otherCurrenciesTableDataSource.detailsScreen = self
        
        historicalTableView.delegate = historicalDataTableDataSource
        historicalTableView.dataSource = historicalDataTableDataSource
        
        otherCurrenciesTableView.delegate = otherCurrenciesTableDataSource
        otherCurrenciesTableView.dataSource = otherCurrenciesTableDataSource
        
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
            .asDriver(onErrorJustReturn: "unknown error")
            .drive(onNext: { [unowned self] errorMessage in
                self.showAlert(message: errorMessage)
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
                
                if isLoading {
                    self.showActivityIndicator(view: self.indicatorView,
                                               indicator: self.activityIndicator)
                } else {
                    self.hideActivityIndicator(view: self.indicatorView,
                                               indicator: self.activityIndicator)
                }
                print(isLoading, "is loading")
            }).disposed(by: disposeBag)
        
    }

    @IBOutlet weak var fromCurrencyLbl: UILabel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var otherCurrenciesTableView: UITableView!
    
    @IBOutlet weak var historicalTableView: UITableView!
    @IBOutlet weak var charView: UIView!
}


protocol DetailViewControllerProtocol: AnyObject {
    var historicalData: [HistoryDataItem] {get}
    var fromCurrency: CurrencyRate! {get}
    var toCurrency: CurrencyRate! {get}
    var decimalRatesFrom: [DecimalResult] {get}
}

// MARK: Data sources
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


// MARK: Data sources
class OtherCurrenciesTableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var detailsScreen: DetailViewControllerProtocol!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsScreen.decimalRatesFrom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        
        if 0..<detailsScreen.decimalRatesFrom.count ~= indexPath.row {
            
            let iso = detailsScreen.decimalRatesFrom[indexPath.row].orginalISO
            let decimalResult = detailsScreen.decimalRatesFrom[indexPath.row].result
            
//            let fromRate = detailsScreen.decimalRatesFrom[indexPath.row].fromCurrency.rate
//            let toRate = detailsScreen.decimalRatesFrom[indexPath.row].toCurrencyRate.rate
//

            
            cell.textLabel?.text = "\(iso): \(decimalResult)"
//            "\(fromCurrncyIso): \(roundedFro) \(toCurrncyIso): \(roundedto)"

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
