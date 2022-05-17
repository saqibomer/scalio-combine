//
//  UsersWebRepositoryTests.swift
//  scalio-test-combineTests
//
//  Created by TOxIC on 17/05/2022.
//

import XCTest
import Combine
@testable import scalio_test_combine

final class UsersWebRepositoryTests: XCTestCase {
    
    private var sut: UsersWebRepositoryImpl!
    private var subscriptions = Set<AnyCancellable>()
    
    typealias API = UsersWebRepositoryImpl.API
    typealias Mock = RequestMocking.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = UsersWebRepositoryImpl(session: .mockedResponsesOnly,
                                         baseURL: "https://api.github.com")
    }

    override func tearDown() {
        RequestMocking.removeAllMocks()
    }
    
    // MARK: - Fetch Users

    func test_fetchUsers() throws {
        let data = UserResponse.mockedData
        try mock(.fetchUsers("saqib", 9, 1), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.fetchUsers(login: "saqib", perPage: 9, page: 1).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
    
    func test_fetchUsersEmptyResponse() throws {
        let data = UserResponse.mockedEmptyUsersData
        try mock(.fetchUsers("saqib", 9, 500), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.fetchUsers(login: "saqib", perPage: 9, page: 500).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
    
   
    
    
    // MARK: - Helper
    
    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}
