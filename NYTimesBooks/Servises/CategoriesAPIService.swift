//
//  CategoriesAPIService.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation

protocol CategoriesAPIServiceProtocol {
    func getCategories(completion: @escaping (_ articles: [Category]?, _ error: Error?) -> Void)
}

final class CategoriesAPIService: CategoriesAPIServiceProtocol {
    private let apiManager: APIManager

    init() {
        apiManager = AlamofireAPIManager()
    }

    func getCategories(completion: @escaping ([Category]?, Error?) -> Void) {
        apiManager.request(urlString: APIConstants.categoriesURL,
                           method: .get,
                           dataType: CategoryRequestResult.self,
                           headers: nil,
                           parameters: APIConstants.apiKey) { data, error in
            var categories: [Category]?
            if let data {
                categories = []
                data.results.forEach {
                    categories?.append(Category(from: $0))
                }
                completion(categories, nil)
            }

            if let error {
                completion(nil, error)
            }
        }
    }
}
