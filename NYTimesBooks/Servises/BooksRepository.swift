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
                self?.createEntities(from: books, categoryEncodedName: categoryEncodedName)
                if let fetchedBooks = self?.fetchBooks(by: categoryEncodedName) {
                    self?.postBooks(entities: fetchedBooks, categoryEncodedName: categoryEncodedName)
                }
            }
        }
    }

    private func fetchBooks(by categoryEncodedName: String) -> [BookEntity] {
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        request.predicate = getPredicate(by: categoryEncodedName)

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
        clearBooksByCategoryName(categoryEncodedName: categoryEncodedName)
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

    private func getPredicate(by categoryEncodedName: String) -> NSPredicate {
        return NSPredicate(format: "categoryEncodedName = %@", categoryEncodedName)
    }
}
