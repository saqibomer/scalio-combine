//
//  UserResponse.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation

struct UserResponse: Codable, Equatable {
    
    var totalCount: Int
    var inCompleteResult: Bool
    var users: [User]
    
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case inCompleteResult = "incomplete_results"
        case users = "items"
    }
}


extension UserResponse {
    
    static let mockedData: UserResponse = UserResponse(
                                                        totalCount: User.mockedData.count,
                                                        inCompleteResult: false,
                                                        users: User.mockedData)
    
    static let mockedEmptyUsersData: UserResponse = UserResponse(
                                                        totalCount: User.mockedData.count,
                                                        inCompleteResult: false,
                                                        users: [])
    
}

