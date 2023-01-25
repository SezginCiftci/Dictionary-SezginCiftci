//
//  UIViewController+Extension.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 25.01.2023.
//

import UIKit

extension UIViewController {
    func showAlertView(title: String, message: String, style: UIAlertController.Style = .alert, alertActions: [UIAlertAction]) {
        var actions = alertActions
        if actions.isEmpty {
            actions.append(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
