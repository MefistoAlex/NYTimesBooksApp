//
//  BooksAPIService.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation

// MARK: - Protocol

protocol BooksAPIServiceProtocol {
    func getBooksByCategoryName(categoryName: String, completion: @escaping (_ books: [Book]?, _ error: Error?) -> Void)
}

final class BooksAPIService: BooksAPIServiceProtocol {
    private let apiManager: APIManager
    init() {
        apiManager = AlamofireAPIManager()
    }

    func getBooksByCategoryName(categoryName: String, completion: @escaping ([Book]?, Error?) -> Void) {
        var parameters = APIConstants.apiKey
        parameters["list"] = categoryName

        apiManager.request(urlString: APIConstants.booksURL,
                           method: .get,
                           dataType: BookRequestResult.self,
                           headers: nil,
                           parameters: parameters) { data, error in
            var books: [Book]?

            if let data {
                books = []
                for incomingBookData in data.results {
                    let book = Book(from: incomingBookData, categoryEncodedName: categoryName)
                    books?.append(book)
                }
                completion(books, nil)
            }

            if let error {
                completion(nil, error)
            }
        }
    }
}
