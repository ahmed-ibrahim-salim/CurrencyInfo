//
//  TablesDataSources.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 05/06/2023.
//

import UIKit


protocol DetailViewControllerProtocol: AnyObject {
    var historicalData: [HistoryDataItem] {get}
    var fromCurrency: CurrencyRate! {get}
    var toCurrency: CurrencyRate! {get}
    var decimalRatesFrom: [DecimalResult] {get}
}

// MARK: Historical Data
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
            
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 13)

            cell.textLabel?.text = "\(fromCurrncyIso): \(roundedFro) \(toCurrncyIso): \(roundedto)"

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func round(num: Double) -> Decimal {
        
        var fromRate = Decimal(num)
        var roundedResult = Decimal()
        NSDecimalRound(&roundedResult, &fromRate, 2, .bankers)
        
        return roundedResult
    }
}


// MARK: Other Currencies
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
            
            cell.textLabel?.text = "\(iso): \(decimalResult)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
