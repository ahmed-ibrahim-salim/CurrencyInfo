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
        
        fromCurrencyTable.delegate = self
        fromCurrencyTable.dataSource = self
     
        
        toCurrencyTable.delegate = self
        toCurrencyTable.dataSource = self
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
        
        addFromCurrencyTableToScreen()
    }
    @IBAction func toCurrencyAction(_ sender: Any) {
        addToCurrencyTableToScreen()

    }
    
    @IBAction func openDetailsAction(_ sender: Any) {
    }
}


extension ConverterScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(table: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == fromCurrencyTable{
            
            return viewModel.getFromTableView_Cell(UITableView: tableView, indexPath: indexPath)
        }else{
            return viewModel.getToTableView_Cell(UITableView: tableView, indexPath: indexPath)

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeFromSuperview()
    }
}

enum ScreenTable: Int{
    case fromCurrencyTable
    case toCurrencyTable
}
