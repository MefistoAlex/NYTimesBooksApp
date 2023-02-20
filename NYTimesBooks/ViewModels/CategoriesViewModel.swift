//
//  CategoriesViewModel.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
import RxSwift

final class CategoriesViewModel {
    var categoriesError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var categories: Observable<[Category]> { categoriesSubject }
    private let categoriesSubject = BehaviorSubject(value: [Category]())

    private let categoriesRepository = CategoriesRepository()
    let disposeBag = DisposeBag()

    init() {

        categoriesRepository.categories.bind {[weak self] categories in
            self?.categoriesSubject.onNext(categories)
        }.disposed(by: disposeBag)

        categoriesRepository.categoriesError.bind {[weak self] error in
            self?.errorSubject.onNext(error)
        }.disposed(by: disposeBag)
    }

    func getCategories() {
        categoriesRepository.getCategories()
    }
}
