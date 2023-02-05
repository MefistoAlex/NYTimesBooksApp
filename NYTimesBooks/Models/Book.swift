//
//  Book.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
struct Book {
    let title: String
    let description: String
    let author: String
    let publisher: String
    let isnb13: String
    let amazonUrl: String
    let rank: Int

    init(from incomingBook: BookRequestResult.BookIncoming) {
        title = incomingBook.bookDetail[0].description
        description = incomingBook.bookDetail[0].description
        author = incomingBook.bookDetail[0].author
        publisher = incomingBook.bookDetail[0].publisher
        isnb13 = incomingBook.bookDetail[0].isnb13
        amazonUrl = incomingBook.amazonUrl
        rank = incomingBook.rank
    }
    

    init(title: String, description: String, author: String, publisher: String, isnb13: String, amazonUrl: String, rank: Int) {
        self.title = title
        self.description = description
        self.author = author
        self.publisher = publisher
        self.isnb13 = isnb13
        self.amazonUrl = amazonUrl
        self.rank = rank
    }
}
