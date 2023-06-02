//
//  TableViewDataSources.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 02/06/2023.
//

import UIKit

protocol ConverterScreenControllerProtocol: AnyObject{
    var fromCurrencyTable: UITableView! { get }
    var currencyList: [CurrencyRate] { get set}
}

class TablesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    weak var converterScreen: ConverterScreenControllerProtocol!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(table: tableView)
    }
    
    // MARK: CellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == converterScreen!.fromCurrencyTable{
            
            return getFromTableView_Cell(UITableView: tableView, indexPath: indexPath)
        }else{
            return getToTableView_Cell(UITableView: tableView, indexPath: indexPath)

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeFromSuperview()
    }

    // MARK: Helper Methods
    private func getNumberOfRows(table: UITableView)->Int{
        
        guard !converterScreen.currencyList.isEmpty else{
            return 0
        }
        
        return converterScreen.currencyList.count

        
    }
    private func getFromTableView_Cell(UITableView: UITableView, indexPath: IndexPath)->UITableViewCell{
        
        let cell = UITableViewCell()
        
        if 0..<converterScreen.currencyList.count ~= indexPath.row{
            
            cell.textLabel?.text = converterScreen.currencyList[indexPath.row].iso

        }else{
            cell.textLabel?.text = ""
        }
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
    }
    private func getToTableView_Cell(UITableView: UITableView, indexPath: IndexPath)->UITableViewCell{
        
        let cell = UITableViewCell()
        
        if 0..<converterScreen.currencyList.count ~= indexPath.row{
            
            cell.textLabel?.text = converterScreen.currencyList[indexPath.row].iso

        }else{
            cell.textLabel?.text = ""
        }
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
    }
}
