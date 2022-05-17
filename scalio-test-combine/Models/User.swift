//
//  User.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import Foundation

struct User: Codable,Identifiable, Equatable {
    
    var login: String
    var id: Int
    var avatarUrl: String
    var profileUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case profileUrl = "url"
    }
}



extension User {
    static let mockedData: [User] = [
                                        User(
                                            login: "Saqib",
                                            id: 1,
                                            avatarUrl: "https://avatars.githubusercontent.com/u/33384?v=4",
                                            profileUrl: "https://api.github.com/users/foo"),
                                        
                                        User(
                                            login: "Omer",
                                            id: 1,
                                            avatarUrl: "https://avatars.githubusercontent.com/u/83657?v=4",
                                            profileUrl: "https://api.github.com/users/foosel"),
                                        User(
                                            login: "foone",
                                            id: 1,
                                            avatarUrl: "https://avatars.githubusercontent.com/u/83657?v=4",
                                            profileUrl: "https://api.github.com/users/foosel"),
                                    ]
}
