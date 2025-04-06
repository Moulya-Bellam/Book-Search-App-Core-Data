//
//  CoreDataManager.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/6/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    func fetchFavorites() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    func addFavorite(book: Book) {
        guard !isFavorite(book: book) else { return }
        let entity = BookEntity(context: context)
        entity.id = book.id
        entity.title = book.title
        entity.authors = book.authors.joined(separator: ", ")
        entity.coverImageUrl = book.coverImageUrl
        entity.publisher = book.publisher
        entity.bookDescription = book.bookDescription
        saveContext()
    }
    
    func removeFavorite(book: Book) {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", book.id)
        do {
            let results = try context.fetch(request)
            for obj in results {
                context.delete(obj)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func isFavorite(book: Book) -> Bool {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", book.id)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking favorite: \(error)")
            return false
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
