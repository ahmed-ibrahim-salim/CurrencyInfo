//
//  ViewController.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 31/05/2023.
//

import UIKit
import RxSwift

class ConverterScreen: UIViewController, ConverterScreenControllerProtocol {
    
    
    // MARK: Vars
    var viewModel: ConverterScreenViewModel!
    var availableCurrencies: [CurrencyRate] = []
    let disposeBag = DisposeBag()
    
    
    var tablesDataSource: TablesDataSource?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(didBecomeActiveThenRefresh),
                                                       name: UIApplication.didBecomeActiveNotification,
                                                       object: nil)
        

        setupTableViewDataSources()
        
        let latestRatesService = LatestRates()
        
        viewModel = ConverterScreenViewModel(latestRatesService)
        
        bindViewModel()

        
    }
    func setupTableViewDataSources(){
        tablesDataSource = TablesDataSource()
        tablesDataSource!.converterScreen = self
        
        fromCurrencyTable.delegate = tablesDataSource
        fromCurrencyTable.dataSource = tablesDataSource
        
        toCurrencyTable.delegate = tablesDataSource
        toCurrencyTable.dataSource = tablesDataSource
        
        
    }
    
    
    @objc private func didBecomeActiveThenRefresh() {
        viewModel.input.reload.accept(())
        
    }
    
    var currencyList = [CurrencyRate]()
    
    //  MARK: ViewModel Binding
    func bindViewModel() {
        
        // MARK: Inputs
//
        
        //MARK: outputs
        viewModel.output.rates.drive(onNext: { [unowned self] currencyList in
            self.currencyList = currencyList
            toCurrencyTable.reloadData()
            fromCurrencyTable.reloadData()
            
        }).disposed(by: disposeBag)
        
    }

    var fromCurrencyTable: UITableView! = {
        
        let mainTableView = UITableView(frame: CGRectZero)
        
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.tableFooterView = UIView()
        
        //        mainTableView.contentInsetAdjustmentBehavior = .never
        //        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.separatorStyle = .none
        
        mainTableView.estimatedRowHeight = 20.0
        mainTableView.rowHeight = UITableView.automaticDimension
        
        mainTableView.layer.cornerRadius = 10
        mainTableView.clipsToBounds = true
        
        return mainTableView
        
    }()
    
    func addFromCurrencyTableToScreen(){
        
            view.addSubview(fromCurrencyTable)
            
            NSLayoutConstraint.activate([
                fromCurrencyTable.topAnchor.constraint(equalTo: fromBtn.bottomAnchor),
                fromCurrencyTable.leftAnchor.constraint(equalTo: fromBtn.leftAnchor),
                //            currenciesListTableView.rightAnchor.constraint(equalTo: fromBtn.rightAnchor),
                fromCurrencyTable.heightAnchor.constraint(equalToConstant: 200),
                fromCurrencyTable.widthAnchor.constraint(equalToConstant: fromBtn.frame.width * 2),
                
            ])
        
    }
    
    var toCurrencyTable: UITableView! = {
        
        let mainTableView = UITableView(frame: CGRectZero)
        
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.tableFooterView = UIView()
        
        //        mainTableView.contentInsetAdjustmentBehavior = .never
        //        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.separatorStyle = .none
        
        mainTableView.estimatedRowHeight = 20.0
        mainTableView.rowHeight = UITableView.automaticDimension
        
        mainTableView.layer.cornerRadius = 10
        mainTableView.clipsToBounds = true
        
        return mainTableView
        
    }()
    
    func addToCurrencyTableToScreen(){
        
        
        view.addSubview(toCurrencyTable)
        
        NSLayoutConstraint.activate([
            toCurrencyTable.topAnchor.constraint(equalTo: toBtn.bottomAnchor),
            toCurrencyTable.leftAnchor.constraint(equalTo: toBtn.leftAnchor),
            //            currenciesListTableView.rightAnchor.constraint(equalTo: fromBtn.rightAnchor),
            toCurrencyTable.heightAnchor.constraint(equalToConstant: 200),
            toCurrencyTable.widthAnchor.constraint(equalToConstant: toBtn.frame.width * 2),
            
        ])
    }
    
    // MARK: Outlets
    // for labels
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    
    
    
    // for tests
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var fromCurrencyArrow: UIButton!
    @IBOutlet weak var toCurrencyArrow: UIButton!
    @IBOutlet weak var reverseBtn: UIButton!
    
    @IBOutlet weak var fromCurrencyTxtFiled: UITextField!
    @IBOutlet weak var toCurrencyTxtFiled: UITextField!
    
    // MARK: Actions

    @IBAction func reverseAction(_ sender: Any) {
    }
    
    @IBAction func fromCurrencyAction(_ sender: Any) {
        if !currencyList.isEmpty{
            
            addFromCurrencyTableToScreen()
        }
    }
    @IBAction func toCurrencyAction(_ sender: Any) {
        if !currencyList.isEmpty{
            
            addToCurrencyTableToScreen()
        }
    }
    
    @IBAction func openDetailsAction(_ sender: Any) {
    }
}

