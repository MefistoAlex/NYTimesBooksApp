//
//  CategoriesTableViewController.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import RxCocoa
import RxSwift
import UIKit

class CategoriesTableViewController: UITableViewController {
    // MARK: - Properties

    let disposeBag = DisposeBag()
    var categoriesViewModel = CategoriesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        tableViewConfigure()
        errorHandling()
        categoriesViewModel.getCategories()
    }

    
    //MARK: - TableView
    func tableViewConfigure() {
        tableView.dataSource = nil
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.accessibilityViewIsModal = true
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: String(describing: CategoryTableViewCell.self))
        
        
        categoriesViewModel.categories.asDriver(onErrorJustReturn: [Category]())
            .drive(tableView.rx.items(
                cellIdentifier: String(describing: CategoryTableViewCell.self),
                cellType: CategoryTableViewCell.self)) { _, category, cell in
                    cell.awakeFromNib()
                    cell.setCategory(category)
            }.disposed(by: disposeBag)

        
        tableView.rx.modelSelected(Category.self).asDriver().drive {[weak self] category in
            let bookViewController = BooksTableViewController()
            bookViewController.setCategory(category)
            self?.navigationController?.pushViewController(bookViewController, animated: true)
        }.disposed(by: disposeBag)
        

        tableView.rx.itemSelected.asDriver().drive { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: disposeBag)

        
        categoriesViewModel.categories.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
        }.disposed(by: disposeBag)
    }

    
    @objc func refreshTableData() {
        tableView.refreshControl?.beginRefreshing()
        categoriesViewModel.getCategories()
    }
    
    //MARK: - Error alert
    func errorHandling() {
        categoriesViewModel.categoriesError.subscribe { [weak self] error in
            self?.showErrorAlert(with: error)
            self?.tableView.refreshControl?.endRefreshing()
        }.disposed(by: disposeBag)
    }

    
}
