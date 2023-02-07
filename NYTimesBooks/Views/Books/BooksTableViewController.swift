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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Set Category

    func setCategory(_ category: Category) {
        self.category = category
        tableViewConfigure()
        errorHandling()
        booksViewModel.getBooks(by: category)
    }

    // MARK: - TableView

    func tableViewConfigure() {
        tableView.dataSource = nil

        let refreshControl = UIRefreshControl()
        refreshControl.accessibilityViewIsModal = true
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: String(describing: BookTableViewCell.self))

        booksViewModel.books.asDriver(onErrorJustReturn: [Book]())
            .drive(tableView.rx.items(
                cellIdentifier: String(describing: BookTableViewCell.self),
                cellType: BookTableViewCell.self)) { _, book, cell in
                    cell.awakeFromNib()
                    cell.setBook(book)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Book.self).asDriver().drive {[weak self] book in
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

    @objc func refreshTableData() {
        tableView.refreshControl?.beginRefreshing()
        if let category {
            booksViewModel.getBooks(by: category)
        }
    }

    // MARK: - Error alert

    func errorHandling() {
        booksViewModel.booksError.subscribe { [weak self] error in
            self?.showErrorAlert(with: error)
            self?.tableView.refreshControl?.endRefreshing()
        }.disposed(by: disposeBag)
    }
}
