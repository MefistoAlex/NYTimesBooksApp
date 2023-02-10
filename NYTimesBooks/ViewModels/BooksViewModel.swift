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
    
    private let booksRopository = BooksRepository()
    
    private let disposeBag = DisposeBag()
    
    var booksError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var books: Observable<[Book]> { booksSubject }
    private let booksSubject = BehaviorSubject(value: [Book]())
    
    var isLoading: Observable<Bool> { isLoadingSubject }
    private let isLoadingSubject = PublishSubject<Bool>()


    init() {
        booksService = BooksAPIService()
        
        booksRopository.books.bind {[weak self] books in
            if books.count > 0{
                self?.booksSubject.onNext(books)
            } else {
                
            }
        }.disposed(by: disposeBag)
        
        booksRopository.booksError.bind {[weak self] error in
            self?.errorSubject.onNext(error)
        }.disposed(by: disposeBag)
        
        booksRopository.isLoading.bind {[weak self] isLoading in
            self?.isLoadingSubject.onNext(isLoading)
        }.disposed(by: disposeBag)
    }

    func getBooks(by category: Category) {
        booksRopository.getBooks(by: category.nameEncoded)
    }
}
