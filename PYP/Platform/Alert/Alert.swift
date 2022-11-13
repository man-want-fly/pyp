//
//  Alert.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import UIKit

extension UIViewController {

    func showError(message: String?) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showSuccess(message: String?) {
        let alert = UIAlertController(title: "🎉", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
