//
//  Fakeable.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 06/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

protocol Fakeable {
    static func fake() -> Self
}

extension ActivityType: Fakeable {

    static func fake() -> ActivityType {
        return ActivityType.allCases[Int.random(in: 0 ..< ActivityType.allCases.count)]
    }

}

extension User: Fakeable {

    static func fake() -> User {
        return User(id: ID(rawValue: UUID().hashValue), login: "", avatarUrl: "http://github.com/github.jpg")
    }

}

extension Repository: Fakeable {

    static func fake() -> Repository {
        return Repository(id: ID(rawValue: UUID().hashValue), name: "")
    }

}

extension Activity: Fakeable {

    static func fake() -> Activity {
        return Activity(id: ID(rawValue: UUID().uuidString), type: .fake(), actor: .fake(), repo: .fake(), createdAt: Date(), payload: nil)
    }

}
