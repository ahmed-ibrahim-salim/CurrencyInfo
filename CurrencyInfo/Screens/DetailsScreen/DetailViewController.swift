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
    let disposeBag = DisposeBag()
    
    var fromCurrency: CurrencyRate!
    var toCurrency: CurrencyRate!
    
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
    var historicalDataTableDataSource: HistoricalDataTableDataSource!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let historicalDataService = HistoricalDataService()
        
        viewModel = DetailViewModel(historicalDataService: historicalDataService)

        setupTableViewDataSources()
        
        bindViewModel()
        
        getHistoricalDataLast3Days()
        
        fromCurrencyLbl.text = "From \(fromCurrency.iso) to"
        
                
    }

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

    private func getHistoricalDataLast3Days() {
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

    // MARK: Outlets
    @IBOutlet weak var fromCurrencyLbl: UILabel!
    @IBOutlet weak var otherCurrenciesTableView: UITableView!
    
    @IBOutlet weak var historicalTableView: UITableView!
    @IBOutlet weak var charView: UIView!
}
