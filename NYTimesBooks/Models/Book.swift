//
//  Book.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import Foundation
struct Book {
    let title: String
    let annotation: String
    let author: String
    let publisher: String
    let isnb13: String
    let amazonUrl: String
    let rank: Int
    let categoryEncodedName: String
    let imageURL: String

    init(from incomingBook: BookRequestResult.BookIncoming, categoryName: String) {
        title = incomingBook.bookDetail[0].title
        annotation = incomingBook.bookDetail[0].annotation
        author = incomingBook.bookDetail[0].author
        publisher = incomingBook.bookDetail[0].publisher
        isnb13 = incomingBook.bookDetail[0].isnb13
        amazonUrl = incomingBook.amazonUrl
        rank = incomingBook.rank
        categoryEncodedName = categoryName
        imageURL = "https://storage.googleapis.com/du-prd/books/images/\(isnb13).jpg"
    }

    init(title: String, annotation: String, author: String, publisher: String, isnb13: String, amazonUrl: String, rank: Int, categoryEncodedName: String) {
        self.title = title
        self.annotation = annotation
        self.author = author
        self.publisher = publisher
        self.isnb13 = isnb13
        self.amazonUrl = amazonUrl
        self.rank = rank
        self.categoryEncodedName = categoryEncodedName
        imageURL = "https://storage.googleapis.com/du-prd/books/images/\(isnb13).jpg"
    }
}
