//
//  Category.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//

import Foundation
struct Category: Hashable {
    let name: String
    let nameEncoded: String
    let newestPublishedDate: String

    init(from incomingCategory: CategoryIncoming) {
        name = incomingCategory.name
        nameEncoded = incomingCategory.nameEncoded
        newestPublishedDate = incomingCategory.newestPublishedDate
    }

    init?(from entityCathegory: CategoryEntity) {
        guard let name = entityCathegory.name,
              let nameEncoded = entityCathegory.nameEncoded,
              let newestPublishedDate = entityCathegory.newestPublishedDate else { return nil }

        self.name = name
        self.nameEncoded = nameEncoded
        self.newestPublishedDate = newestPublishedDate
    }

    init(name: String, nameEncoded: String, newestPublishedDate: String) {
        self.name = name
        self.nameEncoded = nameEncoded
        self.newestPublishedDate = newestPublishedDate
    }
}
