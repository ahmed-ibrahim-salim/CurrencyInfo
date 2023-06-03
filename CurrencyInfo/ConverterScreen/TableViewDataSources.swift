//
//  TableViewDataSources.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 02/06/2023.
//

import UIKit

protocol ConverterScreenControllerProtocol: AnyObject{
    var fromCurrencyTable: UITableView! { get }
    var toCurrencyTable: UITableView! { get }
    
    var fromBtn: UIButton! {get}
    var toBtn: UIButton! {get}

    var currencyList: [CurrencyRate] { get set}
}

class TablesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    weak var converterScreen: ConverterScreenControllerProtocol!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(table: tableView)
    }
    
    // MARK: CellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return get_TableView_Cell(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeFromSuperview()
        
        guard 0..<converterScreen.currencyList.count ~= indexPath.row else{
            return
        }
        
        let nameOfBtn = converterScreen.currencyList[indexPath.row].iso
            if tableView == converterScreen!.fromCurrencyTable{
                
                change_FromBtn_Name(nameOfBtn, btn: converterScreen.fromBtn)
            }else{
                change_FromBtn_Name(nameOfBtn, btn: converterScreen.toBtn)
            }
        
    }

    // MARK: Helper Methods
    
    private func change_FromBtn_Name(_ name: String,
                                     btn: UIButton){
        btn.setTitle(name, for: .normal)
    }

    private func getNumberOfRows(table: UITableView)->Int{
        
        guard !converterScreen.currencyList.isEmpty else{
            return 0
        }
        
        return converterScreen.currencyList.count

        
    }
    private func get_TableView_Cell(indexPath: IndexPath)->UITableViewCell{
        
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
