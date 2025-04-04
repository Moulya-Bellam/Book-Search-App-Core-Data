//
//  Book.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/4/25.
//

import Foundation

struct Book: Codable, Identifiable {
    var id: String { isbn_13?.first ?? isbn_10?.first ?? "" }
    let title: String
    var authors: [Author]
    var publishers: [String]
    var publishDate: String
    var number_of_pages: Int?
    var isbn_10: [String]?
    var isbn_13: [String]?
    var cover: Cover?

    struct Author: Codable {
        let name: String
    }

    struct Cover: Codable {
        let small: URL?
        let medium: URL?
        let large: URL?
    }
}
