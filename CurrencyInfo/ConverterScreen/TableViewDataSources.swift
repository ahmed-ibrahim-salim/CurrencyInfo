//
//  TableViewDataSources.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 02/06/2023.
//

import UIKit

class TablesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    weak var converterScreen: ConverterScreen?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(table: tableView)
    }
    
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

        
    private func getNumberOfRows(table: UITableView)->Int{
        
        return 20
    }
    private func getFromTableView_Cell(UITableView: UITableView, indexPath: IndexPath)->UITableViewCell{
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "mido"
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
    }
    private func getToTableView_Cell(UITableView: UITableView, indexPath: IndexPath)->UITableViewCell{
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "ahmed"
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
    }
}
