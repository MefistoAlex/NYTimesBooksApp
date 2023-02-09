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
                let dispatchGroup = DispatchGroup()

                for incomingBookData in data.results {
                    dispatchGroup.enter()
                    var book = Book(from: incomingBookData, categoryEncodedName: categoryName)
                    self.apiManager.request(urlString: Constants.booksImageURL + book.isnb13,
                                            method: .get,
                                            dataType: BookImageRequestResult.self,
                                            headers: nil,
                                            parameters: nil) { data, _ in

                        if let data {
                            book.imageURL = data.items?[0].volumeInfo.imageLinks.link
                            
                        }
                        books?.append(book)
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    completion(books, nil)
                }
            }

            if let error {
                completion(nil, error)
            }
        }
    }

    func getImageByIBSN(ibsn: String, completion: @escaping (String?, Error?) -> Void) {
        apiManager.request(urlString: Constants.booksImageURL + ibsn,
                           method: .get,
                           dataType: BookImageRequestResult.self,
                           headers: nil,
                           parameters: nil) { data, error in

            if let data {
                if let link = data.items?[0].volumeInfo.imageLinks.link {
                    completion(link, nil)
                }
            }

            if let error {
                completion(nil, error)
            }
        }
    }
}
