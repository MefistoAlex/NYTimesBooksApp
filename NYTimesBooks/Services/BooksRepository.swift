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

    var isLoading: Observable<Bool> { isLoadingSubject }
    private let isLoadingSubject = PublishSubject<Bool>()

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
        } else {
            isLoadingSubject.onNext(true)
        }
        booksService.getBooksByCategoryName(categoryName: categoryEncodedName) { [weak self] books, error in
            if let error {
                self?.errorSubject.onNext(error)
            }
            if let books {
                self?.bookssSubject.onNext(books)
                if let fetchedBooks = self?.fetchBooks(by: categoryEncodedName) {
                    if fetchedBooks.count > 0 {
                        self?.updateEntities(
                            books: books,
                            entities: fetchedBooks,
                            categoryEncodedName: categoryEncodedName)
                    } else {
                        self?.createEntities(from: books, categoryEncodedName: categoryEncodedName)
                        self?.postBooks(entities: fetchedBooks, categoryEncodedName: categoryEncodedName)
                    }
                }
            }
        }
    }

    // MARK: - Privates

    private func fetchBooks(by categoryEncodedName: String) -> [BookEntity] {
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        request.predicate = getPredicate(by: categoryEncodedName)

        request.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        let requestResult = try? managedObjectContext.fetch(request)
        return requestResult ?? []
    }

    private func updateEntities(books: [Book], entities: [BookEntity], categoryEncodedName: String) {
        if books.count != entities.count {
            clearBooksByCategoryName(categoryEncodedName: categoryEncodedName)
            createEntities(from: books, categoryEncodedName: categoryEncodedName)
        } else {
            for index in 0 ..< books.count {
                let entity = entities[index]
                let book = books[index]
                entity.title = book.title
                entity.author = book.author
                entity.annotation = book.annotation
                entity.amazonURL = book.amazonURL
                entity.isnb13 = book.isnb13
                entity.rank = book.rank
                entity.publisher = book.publisher
                entity.imageURL = book.imageURL
            }
            CoreDataStack.saveContext()
            postBooks(entities: entities, categoryEncodedName: categoryEncodedName)
        }
    }

    private func postBooks(entities: [BookEntity], categoryEncodedName: String) {
        var models = [Book]()
        entities.forEach {
            if let book = Book(from: $0, categoryEncodedName: categoryEncodedName) {
                models.append(book)
            }
        }
        bookssSubject.onNext(models)
        isLoadingSubject.onNext(false)
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
        let request = BookEntity.fetchRequest() as? NSFetchRequest<NSFetchRequestResult>
        request?.predicate = getPredicate(by: categoryEncodedName)
        guard let request else { return }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
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
