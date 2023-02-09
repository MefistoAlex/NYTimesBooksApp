//
//  CategoriesRepository.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 08.02.2023.
//

import CoreData
import Foundation
import RxSwift
final class CategoriesRepository {
    // MARK: - Properties

    let categoriesService: CategoriesAPIService
    let coreData = CoreDataStack()

    var categoriesError: Observable<Error> { errorSubject }
    private let errorSubject = PublishSubject<Error>()

    var categories: Observable<[Category]> { categoriesSubject }
    private let categoriesSubject = BehaviorSubject(value: [Category]())

    init() {
        categoriesService = CategoriesAPIService()
    }

    func getCategories() {
        let fetchedCategories = fetchCategories()
        if fetchedCategories.count > 0 {
            postCategoties(entities: fetchedCategories)
        }
       refreshCategories()
        
    }

    // MARK: - Privates

    private func refreshCategories () {
        categoriesService.getCategories { [weak self] categories, error in
            if let error {
                self?.errorSubject.onNext(error)
            }
            if let categories {
                self?.createEntities(from: categories)
                if let fetchedCategories = self?.fetchCategories() {
                    self?.postCategoties(entities: fetchedCategories)
                }
            }
        }
    }
    private func fetchCategories() -> [CategoryEntity] {
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        let request = CategoryEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let requestResult = try? managedObjectContext.fetch(request)
        return requestResult ?? []
    }

    private func postCategoties(entities: [CategoryEntity]) {
        var models = [Category]()
        entities.forEach {
            if let category = Category(from: $0) {
                models.append(category)
            }
        }
        categoriesSubject.onNext(models)
    }

    private func createEntities(from categories: [Category]) {
        clearData()
        let managedObjectContext = CoreDataStack.persistentContainer.viewContext
        for category in categories {
            let categoryEntity = CategoryEntity(context: managedObjectContext)
            categoryEntity.name = category.name
            categoryEntity.nameEncoded = category.nameEncoded
            categoryEntity.newestPublishedDate = category.newestPublishedDate
        }
        CoreDataStack.saveContext()
    }

    func clearData() {
        let moc = CoreDataStack.persistentContainer.viewContext
        let request = CategoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try moc.execute(deleteRequest)
        } catch {
            fatalError("Error in clearing data sample")
        }
    }
}
