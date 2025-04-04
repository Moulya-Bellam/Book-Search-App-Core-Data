//
//  APIService.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/4/25.
//

import Foundation
import Combine

class APIService {
    func fetchBookDetails(byISBN isbn: String) -> AnyPublisher<Book, Error> {
        let urlString = "https://openlibrary.org/isbn/\(isbn).json"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Book.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
