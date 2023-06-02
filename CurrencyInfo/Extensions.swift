//
//  Extenstions.swift
//  CurrencyInfo
//
//  Created by magdy khalifa on 31/05/2023.
//

import UIKit

extension UIViewController{
    func showAlert(_ title: String? = "",
                   message: String?,
                   selfDismissing: Bool = true,
                   time: TimeInterval = 3) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.view.alpha = 0.3
        
        if !selfDismissing {
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        
        present(alert, animated: true)
        
        if selfDismissing {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
                t.invalidate()
                alert.dismiss(animated: true)
            }
        }
    }
}
