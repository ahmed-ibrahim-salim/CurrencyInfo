//
//  DetailViewController.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 04/06/2023.
//

import UIKit

class DetailViewController: UIViewController {

    var viewModel: DetailViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let historicalDataService = HistoricalDataService()
        
        viewModel = DetailViewModel(historicalDataService: historicalDataService)

        
        viewModel.getHistoricalDataForPast3Days()
    }
    

    @IBOutlet weak var otherCurrenciesTableView: UITableView!
    
    @IBOutlet weak var historicalTableView: UITableView!
    @IBOutlet weak var charView: UIView!
}
