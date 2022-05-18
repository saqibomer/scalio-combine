//
//  RootViewAppearance.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//
import SwiftUI
import Combine

// MARK: - RootViewAppearance

struct RootViewAppearance: ViewModifier {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false
    internal let inspection = Inspection<Self>()
    
    func body(content: Content) -> some View {
        content
            .onReceive(stateUpdate) { self.isActive = $0 }
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var stateUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.system.isActive)
    }
}
