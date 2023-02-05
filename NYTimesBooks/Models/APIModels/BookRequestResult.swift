//
//  BookRequestResult.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//
import Foundation
struct BookRequestResult: Decodable {
    let status: String
    let num_results: Int
    let results: [BookIncoming]

    struct BookIncoming: Decodable {
        let amazonUrl: String
        let rank: Int
        let bookDetail: [BookDetail]

        enum CodingKeys: String, CodingKey {
            case amazonUrl = "amazon_product_url"
            case rank = "rank"
            case bookDetail = "book_details"
        }

        struct BookDetail: Decodable {
            let title: String
            let description: String
            let author: String
            let publisher: String
            let isnb13: String
            
            enum CodingKeys: String, CodingKey {
                case title = "title"
                case description = "description"
                case author = "author"
                case publisher = "publisher"
                case isnb13 = "primary_isbn13"
            }
        }
    }
}
