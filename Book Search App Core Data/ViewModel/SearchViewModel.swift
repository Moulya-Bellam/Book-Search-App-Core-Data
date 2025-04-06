//
//  SearchViewModel.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/6/25.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func search() {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        APIService.shared.searchBooks(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let books):
                self.books = books
                for (index, book) in self.books.enumerated() {
                    if book.publisher == "Unknown Publisher", let coverEditionKey = book.coverEditionKey {
                        APIService.shared.fetchPublisher(for: coverEditionKey) { publisher in
                            if let publisher = publisher {
                                DispatchQueue.main.async {
                                    self.books[index] = Book(
                                        id: book.id,
                                        title: book.title,
                                        authors: book.authors,
                                        coverImageUrl: book.coverImageUrl,
                                        publisher: publisher,
                                        bookDescription: book.bookDescription,
                                        coverEditionKey: book.coverEditionKey
                                    )
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
