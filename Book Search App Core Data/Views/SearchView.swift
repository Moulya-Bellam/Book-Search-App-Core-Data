//
//  SearchView.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchVM = SearchViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search books...", text: $searchVM.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.search)
                        .onSubmit {
                            searchVM.search()
                        }
                    
                    Button(action: {
                        searchVM.search()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                if searchVM.isLoading {
                    ProgressView("Searching...")
                } else if let errorMessage = searchVM.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(searchVM.books) { book in
                        BookRowView(
                            book: book,
                            isFavorite: favoritesVM.isFavorite(book: book),
                            favoriteAction: {
                                favoritesVM.toggleFavorite(book: book)
                            }
                        )
                    }
                }
            }
            .navigationTitle("Book Search")
        }
    }
}
