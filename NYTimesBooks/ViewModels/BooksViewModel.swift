//
//  BooksViewModel.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 06.02.2023.
//

import Foundation
import RxSwift

class BooksViewModel {
    private let booksService: BooksAPIServiceProtocol
    var booksError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var books: Observable<[Book]> { booksSubject }
    private let booksSubject = BehaviorSubject(value: [Book]())

    init() {
        booksService = BooksAPIService()
    }

    func getBooks(by category: Category) {
        booksService.getBooksByCategoryName(categoryName: category.nameEncoded) { [weak self] books, error in
            if let error {
                self?.errorSubject.onNext(error)
            }
            if let books {
                self?.booksSubject.onNext(books)
            }
        }
    }
}
