//
//  Extenstions.swift
//  CurrencyInfo
//
//  Created by Ahmed medo on 31/05/2023.
//

import UIKit

extension UIViewController {
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
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
                timer.invalidate()
                alert.dismiss(animated: true)
            }
        }
    }
    
    func showActivityIndicator(view: UIView, indicator: UIActivityIndicatorView) {
//        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        
//        indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.frame = CGRect(x: 0, y: 0, width: indicator.bounds.size.width, height: indicator.bounds.size.height)
        
        indicator.center = view.center
        view.addSubview(indicator)
        view.center = self.view.center
        self.view.addSubview(view)
        
        indicator.startAnimating()
    }
    
    func hideActivityIndicator(view: UIView, indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        view.removeFromSuperview()
    }
}
