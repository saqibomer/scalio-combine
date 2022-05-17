//
//  UserssWebRepository.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation
import Combine

protocol UsersWebRepository: WebRepository {
    func fetchUsers(login: String, perPage: Int, page: Int) -> AnyPublisher<UserResponse, Error>
}

struct UsersWebRepositoryImpl: UsersWebRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchUsers(login: String, perPage: Int, page: Int) -> AnyPublisher<UserResponse, Error> {
        return call(endpoint: API.fetchUsers(login, perPage, page))
    }
}

// MARK: - Endpoints

extension UsersWebRepositoryImpl {
    enum API {
        case fetchUsers(String, Int, Int)
    }
}

extension UsersWebRepositoryImpl.API: APICall {
    var path: String {
        switch self {
        case let .fetchUsers(login, perPage, page):
            let encoded = login.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return "/search/users?q=\(encoded ?? "")&per_page=\(perPage)&page=\(page)"
        }
    }
    var method: String {
        switch self {
        case .fetchUsers:
            return "GET"
        }
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}
