//
//  FavoritesViewModel.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Book] = []

    init() {
        fetchFavorites()
    }

    func fetchFavorites() {
        let entities = CoreDataManager.shared.fetchFavorites()
        self.favorites = entities.map { entity in
            Book(
                id: entity.id ?? UUID().uuidString,
                title: entity.title ?? "Untitled",
                authors: entity.authors?.components(separatedBy: ", ") ?? [],
                coverImageUrl: entity.coverImageUrl ?? "",
                publisher: entity.publisher ?? "Unknown Publisher",
                bookDescription: entity.bookDescription,
                coverEditionKey: nil
            )
        }
    }

    func addFavorite(book: Book) {
        CoreDataManager.shared.addFavorite(book: book)
        fetchFavorites()
    }

    func removeFavorite(book: Book) {
        CoreDataManager.shared.removeFavorite(book: book)
        fetchFavorites()
    }

    func toggleFavorite(book: Book) {
        if isFavorite(book: book) {
            removeFavorite(book: book)
        } else {
            addFavorite(book: book)
        }
    }

    func isFavorite(book: Book) -> Bool {
        return CoreDataManager.shared.isFavorite(book: book)
    }
}
