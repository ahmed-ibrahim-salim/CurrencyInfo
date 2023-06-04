//
//  From_TextFieldHandler.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 04/06/2023.
//

import UIKit

protocol TextfieldsHandlerProtocol{
    var converterScreen: ConverterScreenControllerProtocol! {get}
  
}


class From_TextFieldHandler: NSObject, UITextFieldDelegate, TextfieldsHandlerProtocol{
    
    weak var converterScreen: ConverterScreenControllerProtocol!
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let returnKeyChar = CharacterSet(charactersIn: "\n")
        
        //      allowing check if char passed is return key, so i can dismiss keyboard
        if let replacementTextIsReturnKeyBtn = string.rangeOfCharacter(from: returnKeyChar){
            return true
        }
        
        let allowedNumbers = CharacterSet.decimalDigits

        // allowing only numbers
        if let replacementTextIsNumber = string.rangeOfCharacter(from: allowedNumbers){
            return true
        }else if string != ""{
            return false
        }
            
        return true
        
    }
}

class To_TextFieldHandler: NSObject, UITextFieldDelegate, TextfieldsHandlerProtocol{
    
    weak var converterScreen: ConverterScreenControllerProtocol!

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let returnKeyChar = CharacterSet(charactersIn: "\n")
        
        //      allowing check if char passed is return key, so i can dismiss keyboard
        if let replacementTextIsReturnKeyBtn = string.rangeOfCharacter(from: returnKeyChar){
            return true
        }
        
        let allowedNumbers = CharacterSet.decimalDigits

        // allowing only numbers
        if let replacementTextIsNumber = string.rangeOfCharacter(from: allowedNumbers){
            return true
        }else if string != ""{
            return false
        }
            
        return true

    }
}


