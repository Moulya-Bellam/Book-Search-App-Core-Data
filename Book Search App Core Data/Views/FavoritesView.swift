//
//  FavoritesView.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesVM.favorites) { book in
                    BookRowView(
                        book: book,
                        isFavorite: true,
                        favoriteAction: {
                            favoritesVM.toggleFavorite(book: book)
                        }
                    )
                }
                .onDelete(perform: deleteFavorite)
            }
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            let book = favoritesVM.favorites[index]
            favoritesVM.removeFavorite(book: book)
        }
    }
}
