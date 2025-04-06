//
//  BookRowView.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/6/25.
//

import SwiftUI

struct BookRowView: View {
    let book: Book
    let isFavorite: Bool
    let favoriteAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            if let url = URL(string: book.coverImageUrl), !book.coverImageUrl.isEmpty {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 75)
                .cornerRadius(4)
            } else {
                Color.gray
                    .frame(width: 50, height: 75)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                if !book.authors.isEmpty {
                    Text(book.authors.joined(separator: ", "))
                        .font(.subheadline)
                }
                Text(book.publisher)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(action: favoriteAction) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
