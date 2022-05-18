//
//  Interactors.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation

extension DIContainer {
    struct Interactors {
        let usersInteractor: UsersInteractor
        
        init(usersInteractor: UsersInteractor) {
            self.usersInteractor = usersInteractor
        }
        
        static var stub: Self {
            .init(usersInteractor: StubUsersInteractor())
        }
    }
}
