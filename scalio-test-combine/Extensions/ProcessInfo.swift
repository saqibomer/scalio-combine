//
//  ProcessInfo.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
