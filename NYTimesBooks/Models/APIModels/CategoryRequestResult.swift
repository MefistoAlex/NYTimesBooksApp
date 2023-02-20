//
//  CategoryRequestResult.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//

import Foundation
struct CategoryRequestResult: Decodable {
    let status: String
    let numResults: Int
    let results: [CategoryIncoming]

    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
}

struct CategoryIncoming: Decodable {
    let name: String
    let nameEncoded: String
    let newestPublishedDate: String

    enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case nameEncoded = "list_name_encoded"
        case newestPublishedDate = "newest_published_date"
    }
}
