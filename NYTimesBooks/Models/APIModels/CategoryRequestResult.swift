//
//  CategoryRequestResult.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//

import Foundation
struct CategoryRequestResult: Decodable {
    let status: String
    let num_results: Int
    let results: [CategoryIncoming]

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
    func toCategories() -> [Category] {
        var categories = [Category]()
        for incomingCategory in results {
            let category = Category(from: incomingCategory)
            categories.append(category)
        }
        return categories
    }
}