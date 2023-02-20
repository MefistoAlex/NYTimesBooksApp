//
//  UIViewController+showErrorAlert.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 06.02.2023.
//
import UIKit
extension UIViewController {
    func showErrorAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Default action"),
            style: .destructive))
        present(alert, animated: true)
    }
}
