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
    
    var from_TextFieldHandler: From_TextFieldHandler?
    
    var to_TextFieldHandler: To_TextFieldHandler?
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
//                NotificationCenter.default.addObserver(self,
//                                                       selector: #selector(didBecomeActiveThenRefresh),
//                                                       name: UIApplication.didBecomeActiveNotification,
//                                                       object: nil)
        

        setupTableViewDataSources()
        
        let latestRatesService = LatestRates()
        
        viewModel = ConverterScreenViewModel(latestRatesService)
        
        bindViewModel()

        setTextFieldsDelegates()
    }
    
    func setTextFieldsDelegates(){
        from_TextFieldHandler = From_TextFieldHandler()
        to_TextFieldHandler =  To_TextFieldHandler()
        
        from_TextFieldHandler?.converterScreen = self
        to_TextFieldHandler?.converterScreen = self
        
        
        fromCurrencyTxtFiled.text = "1"
        
        fromCurrencyTxtFiled.delegate = from_TextFieldHandler
        toCurrencyTxtFiled.delegate = to_TextFieldHandler

        
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
    
    let changeFromCurrencyBtn = BehaviorSubject<CurrencyRate>(value: CurrencyRate(iso: "From", rate: 1))
    let changeToCurrencyBtn = BehaviorSubject<CurrencyRate>(value: CurrencyRate(iso: "To", rate: 1))
    
    
    var from_TextFieldChanged = PublishSubject<String>()
    
    var to_TextFieldChanged = PublishSubject<String>()
    
    func bindViewModel() {
        
        // MARK: Inputs
        
        changeFromCurrencyBtn
            .subscribe{
                [unowned self] currencyRate in
                self.viewModel.input.changeFromBtnName.on(currencyRate)
                
                self.updateRatesValues()
                
            }
            .disposed(by: disposeBag)
        
        changeToCurrencyBtn
            .subscribe{
                [unowned self] currencyRate in
                self.viewModel.input.changeToBtnName.on(currencyRate)
                
                self.updateRatesValues()
                
            }
            .disposed(by: disposeBag)
        
        from_TextFieldChanged
            .subscribe{
             [unowned self] string in
                
                print(string)
                do{
                    let fromValue = try changeFromCurrencyBtn.value().rate
                    let toValue = try changeToCurrencyBtn.value().rate
                    
                    let decimalNum = viewModel.getCurrencyBy(entry: string.element,
                                                             fromRate: fromValue,
                                                             toRate: toValue)
                    
                    viewModel.input.from_TextFieldChanged.onNext(decimalNum)
                }catch{
                    print(error)
                }
                
                
            }
            .disposed(by: disposeBag)
                
        
        to_TextFieldChanged
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe{
             [unowned self] string in
                
                print(string)
                do{
                    let fromValue = try changeToCurrencyBtn.value().rate
                    let toValue = try changeFromCurrencyBtn.value().rate
                    
                    let decimalNum = viewModel.getCurrencyBy(entry: string.element,
                                                             fromRate: fromValue,
                                                             toRate: toValue)
                    
                    viewModel.input.to_TextFieldChanged.onNext(decimalNum)
                }catch{
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        //MARK: outputs
        viewModel.output.rates.drive(onNext: { [unowned self] currencyList in
            self.currencyList = currencyList
            toCurrencyTable.reloadData()
            fromCurrencyTable.reloadData()
            
        }).disposed(by: disposeBag)
        
        
        viewModel.output.fromBtnName
            .drive{ [unowned self] currencyRate in
                self.fromBtn.setTitle(currencyRate.iso, for: .normal)
            }
            .disposed(by: disposeBag)

        viewModel.output.toBtnName
            .drive{[unowned self] currencyRate in
            self.toBtn.setTitle(currencyRate.iso, for: .normal)
            }.disposed(by: disposeBag)
        
        
        viewModel.output.from_TextFieldChanged
            .drive{
                [unowned self] decimal in
                
                toCurrencyTxtFiled.text = decimal.description
            }.disposed(by: disposeBag)

        
        viewModel.output.to_TextFieldChanged
            .drive{
                [unowned self] decimal in
                
                fromCurrencyTxtFiled.text = decimal.description
            }.disposed(by: disposeBag)
        
    }

    // MARK: UIElements
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
    func swapRates() throws{
        let fromRate = try changeFromCurrencyBtn.value()
        let toRate = try changeToCurrencyBtn.value()
        
        if fromRate.iso != "From" && toRate.iso != "To"{
            changeFromCurrencyBtn.onNext(toRate)
            
            changeToCurrencyBtn.onNext(fromRate)
            
            // updating
            updateRatesValues()
        }

    }
    
    private func updateRatesValues(){
        guard let fromText = fromCurrencyTxtFiled.text else{
            return
        }
        
        from_TextFieldChanged.onNext(fromText)
    }
    
    @IBAction func swapRatesAction(_ sender: Any) {
        do{
            try swapRates()
        }catch{
            print(error)
        }
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
        let detailsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController")
        
        navigationController?.pushViewController(detailsVc, animated: true)
    }
}
