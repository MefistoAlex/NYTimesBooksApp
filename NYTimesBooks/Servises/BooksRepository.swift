//
//  BooksRepository.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 08.02.2023.
//

import CoreData
import Foundation
import RxSwift
final class BooksRepository {
    // MARK: - Properties

    let booksService: BooksAPIServiceProtocol
    let booksImageService: BooksImageAPIServiceProtocol

    var booksError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var books: Observable<[Book]> { bookssSubject }
    private let bookssSubject = BehaviorSubject(value: [Book]())

    init() {
        booksService = BooksAPIService()
        booksImageService = BooksImageAPIService()
    }

    func getBooks(by categoryEncodedName: String) {
        let fetchedBooks = fetchBooks(by: categoryEncodedName)
        if fetchedBooks.count > 0 {
            postBooks(entities: fetchedBooks, categoryEncodedName: categoryEncodedName)
        }
        booksService.getBooksByCategoryName(categoryName: categoryEncodedName) { [weak self] books, error in
            if let error {
                self?.errorSubject.onNext(error)
            }
            if let books {
                self?.clearBooksByCategoryName(categoryEncodedName: categoryEncodedName)
                self?.createEntities(from: books, categoryEncodedName: categoryEncodedName)
                if let fetchedBooks = self?.fetchBooks(by: categoryEncodedName) {
                    self?.postBooks(entities: fetchedBooks, categoryEncodedName: categoryEncodedName)
                    self?.getImages(booksEntities: fetchedBooks, categoryEncodedName: categoryEncodedName)
                }
            }
        }
    }

    private func fetchBooks(by categoryEncodedName: String) -> [BookEntity] {
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        request.predicate = getPredicate(by: categoryEncodedName)

        request.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        let requestResult = try? managedObjectContext.fetch(request)
        return requestResult ?? []
    }

    private func postBooks(entities: [BookEntity], categoryEncodedName: String) {
        var models = [Book]()
        entities.forEach {
            if let book = Book(from: $0, categoryEncodedName: categoryEncodedName) {
                models.append(book)
            }
        }
        bookssSubject.onNext(models)
    }

    private func createEntities(from books: [Book], categoryEncodedName: String) {
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        for book in books {
            let bookEntity = BookEntity(context: managedObjectContext)
            bookEntity.title = book.title
            bookEntity.annotation = book.annotation
            bookEntity.author = book.author
            bookEntity.publisher = book.publisher
            bookEntity.isnb13 = book.isnb13
            bookEntity.amazonURL = book.amazonURL
            bookEntity.rank = book.rank
            bookEntity.categoryEncodedName = categoryEncodedName
            bookEntity.imageURL = book.imageURL
        }
        CoreDataStack.saveContext()
    }

    func clearBooksByCategoryName(categoryEncodedName: String) {
        let moc = CoreDataStack.persistentContainer.viewContext
        let request = BookEntity.fetchRequest()
        request.predicate = getPredicate(by: categoryEncodedName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try moc.execute(deleteRequest)
        } catch {
            errorSubject.onNext(error)
        }
        CoreDataStack.saveContext()
    }

    private func getImages(booksEntities: [BookEntity], categoryEncodedName: String) {
        let group = DispatchGroup()
        for index in 0 ..< booksEntities.count {
            if let ibsn = booksEntities[index].isnb13 {
                group.enter()
                booksImageService.getImageByIBSN(ibsn: ibsn) { bookImage, _ in
                    booksEntities[index].imageURL = bookImage
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.postBooks(entities: booksEntities, categoryEncodedName: categoryEncodedName)
            CoreDataStack.saveContext()
        }
    }
}

private func getPredicate(by categoryEncodedName: String) -> NSPredicate {
    return NSPredicate(format: "categoryEncodedName = %@", categoryEncodedName)
}
