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
        
        currenciesListTableViewForFromAction.delegate = self
        currenciesListTableViewForFromAction.dataSource = self

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
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        addTableViewToScreen()
//    }
    var currenciesListTableViewForFromAction: UITableView! = {
        
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
    
    func addTableViewToScreen(){
        
        
        view.addSubview(currenciesListTableViewForFromAction)
        
        NSLayoutConstraint.activate([
            currenciesListTableViewForFromAction.topAnchor.constraint(equalTo: fromBtn.bottomAnchor),
            currenciesListTableViewForFromAction.leftAnchor.constraint(equalTo: fromBtn.leftAnchor),
//            currenciesListTableView.rightAnchor.constraint(equalTo: fromBtn.rightAnchor),
            currenciesListTableViewForFromAction.heightAnchor.constraint(equalToConstant: 200),
            currenciesListTableViewForFromAction.widthAnchor.constraint(equalToConstant: fromBtn.frame.width * 2),

//            currenciesListTableView.he.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
    @IBAction func toCurrencyAction(_ sender: Any) {
    }
    
    @IBAction func reverseAction(_ sender: Any) {
    }
    
    @IBAction func fromCurrencyAction(_ sender: Any) {
        
        addTableViewToScreen()
    }
    
    @IBAction func openDetailsAction(_ sender: Any) {
        
    }
}


extension ConverterScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "mido"
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenciesListTableViewForFromAction.removeFromSuperview()
    }
}
