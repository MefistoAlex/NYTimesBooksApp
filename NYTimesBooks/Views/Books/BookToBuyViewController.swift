//
//  BookToBuyViewController.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 07.02.2023.
//

import UIKit
import WebKit

class BookToBuyViewController: UIViewController {
    // MARK: - Properties

    private let webView = WKWebView()
    private var bookUrlRequest: URLRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        webViewConfirure()
        if let bookUrlRequest {
            webView.load(bookUrlRequest)
        } else {
            showAllert()
        }
    }

    // MARK: UI Configure

    private func webViewConfirure() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ]
        )
    }
    
    private func showAllert() {

    }
    
    func setBook(_ book: Book) {
        let url = URL(string: book.amazonURL)
        if let url {
            bookUrlRequest = URLRequest(url: url)
        }
    }
}
