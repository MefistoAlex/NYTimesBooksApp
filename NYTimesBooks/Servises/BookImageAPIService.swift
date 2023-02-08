//
//  BookImageAPIService.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 08.02.2023.
//

import Foundation
protocol BooksImageAPIServiceProtocol {
    func getImageByIBSN(ibsn: String ,completion: @escaping (_ bookImage: String?, _ error: Error?) -> Void)
}
final class BooksImageAPIService: BooksImageAPIServiceProtocol {
    
    private let apiManager: APIManager

    init() {
        apiManager = AlamofireAPIManager()
    }
    
    func getImageByIBSN(ibsn: String, completion: @escaping (String?, Error?) -> Void) {
        apiManager.request(urlString: (Constants.booksImageURL + ibsn),
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
