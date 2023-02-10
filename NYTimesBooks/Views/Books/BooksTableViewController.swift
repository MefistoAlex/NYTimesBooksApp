//
//  BooksTableViewController.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 06.02.2023.
//

import RxCocoa
import RxSwift
import UIKit

class BooksTableViewController: UITableViewController {
    // MARK: - Properties

    private var category: Category?
    let disposeBag = DisposeBag()
    let booksViewModel = BooksViewModel()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.backgroundColor = .systemBackground
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Set Category

    func setCategory(_ category: Category) {
        self.category = category
        tableViewConfigure()
        errorHandling()
        refreshControllConfigure()
        loadingIndicatorConfigure()
        booksViewModel.getBooks(by: category)
    }

    // MARK: - TableView

    func tableViewConfigure() {
        tableView.dataSource = nil

        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: String(describing: BookTableViewCell.self))

        booksViewModel.books.asDriver(onErrorJustReturn: [Book]())
            .drive(tableView.rx.items(
                cellIdentifier: String(describing: BookTableViewCell.self),
                cellType: BookTableViewCell.self)) { _, book, cell in
                    cell.awakeFromNib()
                    cell.setBook(book)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Book.self).asDriver().drive { [weak self] book in
            let bookToBuyController = BookToBuyViewController()
            bookToBuyController.setBook(book)
            self?.navigationController?.pushViewController(bookToBuyController, animated: true)
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver().drive { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: disposeBag)

        booksViewModel.books.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
        }.disposed(by: disposeBag)
    }

    func refreshControllConfigure() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .allEvents)
    }

    @objc func refresh() {
        if let category {
            booksViewModel.getBooks(by: category)
        }
    }

    func loadingIndicatorConfigure() {
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        booksViewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
            self?.loadingIndicator.isHidden = !isLoading
        }.disposed(by: disposeBag)
    }

    // MARK: - Error alert

    func errorHandling() {
        booksViewModel.booksError.subscribe { [weak self] error in
            self?.showErrorAlert(with: error)
            self?.tableView.refreshControl?.endRefreshing()
        }.disposed(by: disposeBag)
    }
}
