//
//  scalio_test_combineApp.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import SwiftUI

@main
struct scalio_test_combineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
