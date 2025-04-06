//
//  Book_Search_App_Core_DataApp.swift
//  Book Search App Core Data
//
//  Created by Mounesh on 4/6/25.
//

import SwiftUI

@main
struct Book_Search_App_Core_DataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
