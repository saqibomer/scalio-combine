//
//  scalio_test_combineApp.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import SwiftUI

@main
struct scalio_test_combineApp: App {
    
    let environment = AppEnvironment.bootstrap()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: environment.container)
        }
    }
}
