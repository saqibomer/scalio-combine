//
//  Result+Extensions.swift
//  scalio-test-combineTests
//
//  Created by TOxIC on 17/05/2022.
//
import XCTest
import SwiftUI
import Combine

extension Publisher {
    func publish() -> AnyPublisher<Output, Failure> {
        delay(for: .milliseconds(10), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
