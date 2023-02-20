//
//  BookImageRequestResult.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 08.02.2023.
//

import Foundation
struct BookImageRequestResult: Decodable {
    let items: [BookImageItem]?

    struct BookImageItem: Decodable {
        let volumeInfo: VolumeInfo
    }

    struct VolumeInfo: Decodable {
        let imageLinks: ImageLink
    }

    // swiftlint:disable nesting
    struct ImageLink: Decodable {
        let link: String
        enum CodingKeys: String, CodingKey {
            case link = "thumbnail"
        }
    }
}
