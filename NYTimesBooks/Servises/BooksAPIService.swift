//
//  BooksAPIService.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
protocol BooksAPIServiceProtocol {
    func getBooksByCategoryName(categoryName: String ,completion: @escaping (_ articles: [Book]?, _ error: Error?) -> Void)
}
class BooksAPIService: BooksAPIServiceProtocol {
    private let apiManager: APIManager

    init() {
        apiManager = AlamofireAPIManager()
    }

    func getBooksByCategoryName(categoryName: String, completion: @escaping ([Book]?, Error?) -> Void) {
        var parameters = Constants.apiKey
        parameters["list"] = categoryName
        
        apiManager.request(urlString: Constants.booksURL,
                           method: .get,
                           dataType: BookRequestResult.self,
                           headers: nil,
                           parameters: parameters) { data, error in
            var books: [Book]?
            if let data {
                books = []
                data.results.forEach {
                    books?.append(Book(from: $0, categoryName: categoryName))
                }
                completion(books, nil)
            }

            if let error {
                completion(nil, error)
            }
        }
    }
}
