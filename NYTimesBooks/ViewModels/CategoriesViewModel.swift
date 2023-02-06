//
//  CategoriesViewModel.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
import RxSwift

class CategoriesViewModel {
    private let categoriesService: CategoriesAPIServiceProtocol
    var categoriesError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var categories: Observable<[Category]> { categoriesSubject }
    private let categoriesSubject = BehaviorSubject(value: [Category]())

    init() {
        categoriesService = CategoriesAPIService()
    }

    func getCategories() {
        categoriesService.getCategories { [weak self] categories, error in
            if let error {
                self?.errorSubject.onNext(error)
            }
            if let categories {
                self?.categoriesSubject.onNext(categories)
            }
        }
    }
}
