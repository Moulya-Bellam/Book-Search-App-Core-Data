//
//  Book_Search_App_Core_DataApp.swift
//  Book Search App Core Data
//
//  Created by Moulya on 4/6/25.
//

import SwiftUI

@main
struct Book_Search_App_Core_DataApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var favoritesVM = FavoritesViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(favoritesVM)
        }
    }
}
