//
//  UsersInteractor.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Combine
import Foundation
import SwiftUI

protocol UsersInteractor {
    
    func fetchUsers(response: LoadableSubject<LazyList<User>>, query: String, perPage: Int, page: Int)
    
}

struct UsersInteractorImpl: UsersInteractor {
    
    let webRepository: UsersWebRepository
    let appState: Store<AppState>
    
    init(webRepository: UsersWebRepository,
         appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    

    func fetchUsers(response: LoadableSubject<LazyList<User>>, query: String, perPage: Int, page: Int) {
        
        let cancelBag = CancelBag()
        response.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        return webRepository.fetchUsers(login: query, perPage: perPage, page: page)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map({$0.users.lazyList})
            .sinkToLoadable { response.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubUsersInteractor: UsersInteractor {
    
    func fetchUsers(response: LoadableSubject<LazyList<User>>, query: String, perPage: Int, page: Int) {
    }
}

