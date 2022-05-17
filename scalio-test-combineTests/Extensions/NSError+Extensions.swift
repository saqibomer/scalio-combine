//
//  NSError+Extensions.swift
//  scalio-test-combineTests
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}
