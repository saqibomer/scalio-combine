//
//  Inspector.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Combine

internal final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()
    
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
