//
//  User.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 03/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct User: Decodable, Identifiable {
    typealias RawRepresentation = Int

    let id: ID
    let login: String
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}
