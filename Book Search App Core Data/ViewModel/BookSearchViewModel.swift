//
//  BookSearchViewModel.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/4/25.
//

import Foundation
import Combine

class BookSearchViewModel: ObservableObject {
    @Published var books: [Book] = []
    private var cancellables = Set<AnyCancellable>()
    private var apiService = APIService()

    func searchBook(byISBN isbn: String) {
        apiService.fetchBookDetails(byISBN: isbn)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] book in
                self?.books.append(book)
            })
            .store(in: &cancellables)
    }
}
