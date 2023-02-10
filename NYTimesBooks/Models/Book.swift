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
    let amazonURL: String
    let rank: Int16
    let categoryEncodedName: String
    var imageURL: String?

    init(from incomingBook: BookRequestResult.BookIncoming, categoryEncodedName: String) {
        title = incomingBook.bookDetail[0].title
        annotation = incomingBook.bookDetail[0].annotation
        author = incomingBook.bookDetail[0].author
        publisher = incomingBook.bookDetail[0].publisher
        isnb13 = incomingBook.bookDetail[0].isnb13
        amazonURL = incomingBook.amazonUrl
        rank = incomingBook.rank
        self.categoryEncodedName = categoryEncodedName
        imageURL =  "https://storage.googleapis.com/du-prd/books/images/\(isnb13).jpg"
    }

    init(title: String, annotation: String, author: String, publisher: String, isnb13: String, amazonURL: String, rank: Int16, categoryEncodedName: String, imageURL: String) {
        self.title = title
        self.annotation = annotation
        self.author = author
        self.publisher = publisher
        self.isnb13 = isnb13
        self.amazonURL = amazonURL
        self.rank = rank
        self.categoryEncodedName = categoryEncodedName
        self.imageURL = imageURL
    }

    init? (from entityBook: BookEntity, categoryEncodedName: String) {
        guard let title = entityBook.title,
              let annotation = entityBook.annotation,
              let author = entityBook.author,
              let publisher = entityBook.publisher,
              let isnb13 = entityBook.isnb13,
              let amazonURL = entityBook.amazonURL
        else { return nil }
        self.title = title
        self.annotation = annotation
        self.author = author
        self.publisher = publisher
        self.isnb13 = isnb13
        self.amazonURL = amazonURL
        rank = entityBook.rank
        self.categoryEncodedName = categoryEncodedName
        imageURL = entityBook.imageURL
    }
}
