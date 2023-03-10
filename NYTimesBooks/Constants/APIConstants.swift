//
//  APIConstants.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
struct APIConstants {
    static let apiKey = ["api-key": "sxjwEizy3R3Flcl5LMe6AYkEf9wDpPST"]
    static let categoriesURL = "https://api.nytimes.com/svc/books/v3/lists/names.json"
    static let booksURL = "https://api.nytimes.com/svc/books/v3/lists.json"
    static let booksImageURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
}
