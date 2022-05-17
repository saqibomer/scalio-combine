//
//  MockedWebRepository.swift
//  scalio-test-combineTests
//
//  Created by TOxIC on 17/05/2022.
//

import XCTest
import Combine
@testable import scalio_test_combine

class MockedWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
    let bgQueue = DispatchQueue(label: "test")
}

// MARK: - UsersWebRepository

final class MockedUsersWebRepository: MockedWebRepository, Mock, UsersWebRepository {
    
    enum Action: Equatable {
        case fetchUsers(String, Int, Int)
    }
    var actions = MockActions<Action>(expected: [])
    
//    var usersResponse: Result<UserResponse, Error> = .failure(MockError.valueNotSet)
    var usersResponse: Result<UserResponse, Error> = .failure(MockError.valueNotSet)

    func fetchUsers(login: String, perPage: Int, page: Int) -> AnyPublisher<UserResponse, Error> {
         register(.fetchUsers(login, perPage, page))
        return usersResponse.publish()
        
    }
}


