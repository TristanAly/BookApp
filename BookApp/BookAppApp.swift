//
//  BookAppApp.swift
//  BookApp
//
//  Created by apprenant1 on 18/01/2023.
//

import SwiftUI

@main
struct BookAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
