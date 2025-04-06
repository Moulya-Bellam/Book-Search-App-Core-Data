//
//  Book.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//


import Foundation

struct Book: Identifiable, Codable {
    let id: String
    let title: String
    let authors: [String]
    let coverImageUrl: String
    var publisher: String
    let bookDescription: String?
    let coverEditionKey: String?

    init(id: String,
         title: String,
         authors: [String],
         coverImageUrl: String,
         publisher: String,
         bookDescription: String?,
         coverEditionKey: String?) {
        self.id = id
        self.title = title
        self.authors = authors
        self.coverImageUrl = coverImageUrl
        self.publisher = publisher
        self.bookDescription = bookDescription
        self.coverEditionKey = coverEditionKey
    }

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case publisher
        case coverI = "cover_i"
        case coverEditionKey = "cover_edition_key"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawKey = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.id = rawKey.isEmpty ? UUID().uuidString : rawKey
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled"
        self.authors = try container.decodeIfPresent([String].self, forKey: .authorName) ?? []
        
        if let publisherArray = try container.decodeIfPresent([String].self, forKey: .publisher),
           let firstPublisher = publisherArray.first,
           !firstPublisher.isEmpty {
            self.publisher = firstPublisher
        } else if let publisherString = try container.decodeIfPresent(String.self, forKey: .publisher),
                  !publisherString.isEmpty {
            self.publisher = publisherString
        } else {
            self.publisher = "Unknown Publisher"
        }
        
        if let coverID = try container.decodeIfPresent(Int.self, forKey: .coverI) {
            self.coverImageUrl = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
        } else {
            self.coverImageUrl = ""
        }
        
        self.coverEditionKey = try container.decodeIfPresent(String.self, forKey: .coverEditionKey)
        
                self.bookDescription = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .key)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authorName)
        try container.encode([publisher], forKey: .publisher)
        if let coverID = extractCoverID(from: coverImageUrl) {
            try container.encode(coverID, forKey: .coverI)
        } else {
            try container.encode(0, forKey: .coverI)
        }
        try container.encodeIfPresent(coverEditionKey, forKey: .coverEditionKey)
    }
    
    private func extractCoverID(from url: String) -> Int? {
        guard let range = url.range(of: #"b/id/(\d+)-M"#, options: .regularExpression) else { return nil }
        let substring = url[range]
        let cleaned = substring
            .replacingOccurrences(of: "b/id/", with: "")
            .replacingOccurrences(of: "-M", with: "")
        return Int(cleaned)
    }
}
