//
//  BookSearchView.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/4/25.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject var viewModel = BookSearchViewModel()
    @State private var isbn: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter ISBN", text: $isbn)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Search") {
                    viewModel.searchBook(byISBN: isbn)
                }
                .padding()

                List(viewModel.books, id: \.id) { book in
                    VStack(alignment: .leading) {
                        Text(book.title).font(.headline)
                        Text("Authors: \(book.authors.map(\.name).joined(separator: ", "))")
                        Text("Published: \(book.publishDate)")
                        if let url = book.cover?.medium {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 150)
                        }
                    }
                }
            }
            .navigationBarTitle("Book Search")
        }
    }
}
