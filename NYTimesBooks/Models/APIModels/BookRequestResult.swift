//
//  BookRequestResult.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//
import Foundation
struct BookRequestResult: Decodable {
    let status: String
    let numResults: Int
    let results: [BookIncoming]
    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
}

struct BookIncoming: Decodable {
    let amazonUrl: String
    let rank: Int16
    let bookDetail: [BookDetail]

    enum CodingKeys: String, CodingKey {
        case amazonUrl = "amazon_product_url"
        case rank
        case bookDetail = "book_details"
    }
}

struct BookDetail: Decodable {
    let title: String
    let annotation: String
    let author: String
    let publisher: String
    let isnb13: String
    enum CodingKeys: String, CodingKey {
        case title
        case annotation = "description"
        case author
        case publisher
        case isnb13 = "primary_isbn13"
    }
}
