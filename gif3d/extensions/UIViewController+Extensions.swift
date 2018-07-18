//
//  UIViewController+Extensions.swift
//
//  Created by Sam on 10/13/17.
//  Copyright © 2017 Wooft. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


extension UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "OK", style: .cancel) { _ in

        }
        alert.addAction(Cancel)
        self.present(alert, animated: true) { }
    }

    func showAlert(title: String, message: String, arrButtons: [String], titleDestructive: String?, completion: @escaping(_ index: Int) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if titleDestructive != nil {
            let destructive = UIAlertAction(title: titleDestructive, style: .destructive) { _ in
                completion(0)
            }
            alert.addAction(destructive)
        }

        
        for str in arrButtons {
            let action = UIAlertAction(title: str, style: .default, handler: { (action) in
                completion(arrButtons.index(of: action.title!)! + 1)
            })
            alert.addAction(action)
        }

        self.present(alert, animated: true) { }
    }

//    func showToast(message: String) {
//        Utility.showToast(message: message)
//    }
    
    func showHUD() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    }
    func showHUDWith(text:String) {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = text
    }
    func dismissHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
