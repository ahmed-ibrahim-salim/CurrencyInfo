//
//  TableViewDataSources.swift
//  CurrencyInfo
//
//  Created by Ahmad medo on 02/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol ConverterScreenControllerProtocol: AnyObject{
    var fromCurrencyTable: UITableView! { get }
    var toCurrencyTable: UITableView! { get }
    
    var fromBtn: UIButton! {get}
    var toBtn: UIButton! {get}
    
    var currencyList: [CurrencyRate] { get set}
    
    
    var changeFromCurrencyBtn: BehaviorSubject<CurrencyRate> {get}
    var changeToCurrencyBtn: BehaviorSubject<CurrencyRate> {get}

    
    var fromTextFieldChanged: PublishSubject<String> {get}
    var toTextFieldChanged: PublishSubject<String> {get}
    
    func getNumberOfRows(table: UITableView)->Int

    func get_TableView_Cell(indexPath: IndexPath)->UITableViewCell
    
}

// MARK: Default implem
extension ConverterScreenControllerProtocol{
    func getNumberOfRows(table: UITableView)->Int{
        
        guard !currencyList.isEmpty else{
            return 0
        }
        
        return currencyList.count
        
    }
    
    func get_TableView_Cell(indexPath: IndexPath)->UITableViewCell{
        
        let cell = UITableViewCell()
        
        if 0..<currencyList.count ~= indexPath.row{
            
            cell.textLabel?.text = currencyList[indexPath.row].iso
            
        }else{
            cell.textLabel?.text = ""
        }
        cell.contentView.backgroundColor = .systemGray4
        
        return cell
    }
}

// MARK: DataSource
class TablesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    weak var converterScreen: ConverterScreenControllerProtocol!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return converterScreen.getNumberOfRows(table: tableView)
    }
    
    // MARK: CellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return converterScreen.get_TableView_Cell(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.removeFromSuperview()
        
        guard 0..<converterScreen.currencyList.count ~= indexPath.row else{
            return
        }
        
        let currencyForChosenBtn = converterScreen.currencyList[indexPath.row]
        if tableView == converterScreen!.fromCurrencyTable{
            
            converterScreen.changeFromCurrencyBtn.onNext(currencyForChosenBtn)
        }else{

            converterScreen.changeToCurrencyBtn.onNext(currencyForChosenBtn)
        }
        
    }

    
    
    
}
