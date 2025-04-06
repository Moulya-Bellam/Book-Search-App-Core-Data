//
//  APIServices.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//

import Foundation

struct SearchResult: Codable {
    let docs: [Book]
}

struct EditionDetail: Codable {
    let publishers: [String]?
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard !query.isEmpty else {
            completion(.success([]))
            return
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openlibrary.org/search.json?q=\(encodedQuery)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "No data returned", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.docs))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchPublisher(for coverEditionKey: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://openlibrary.org/books/\(coverEditionKey).json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching edition detail: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data returned for edition detail.")
                completion(nil)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Edition Detail JSON: \(jsonString)")
            }
            
            do {
                let editionDetail = try JSONDecoder().decode(EditionDetail.self, from: data)
                if let publishers = editionDetail.publishers,
                   let publisher = publishers.first,
                   !publisher.isEmpty {
                    print("Found publisher: \(publisher)")
                    completion(publisher)
                } else {
                    print("Publisher not found in edition detail.")
                    completion(nil)
                }
            } catch {
                print("Error decoding edition detail: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
