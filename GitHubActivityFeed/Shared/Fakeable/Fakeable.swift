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
        return User(
            id: ID(rawValue: UUID().hashValue),
            login: "lyzkov",
            avatarUrl: "https://avatars2.githubusercontent.com/u/1086151?s=400&v=4"
        )
    }

}

extension Repository: Fakeable {

    static func fake() -> Repository {
        return Repository(id: ID(rawValue: UUID().hashValue), name: "GitHubActivityFeed")
    }

}

extension Activity: Fakeable {

    static func fake() -> Activity {
        func fakePayload(for type: ActivityType) -> Payload {
            switch type {
            case .fork:
                return ForkPayload.fake()
            case .push:
                return PushPayload.fake()
            case .issues:
                return IssuesPayload.fake()
            case .issueComment:
                return IssueCommentPayload.fake()
            }
        }

        let type = ActivityType.fake()

        return Activity(
            id: ID(rawValue: UUID().uuidString),
            type: type,
            actor: .fake(),
            repo: .fake(),
            createdAt: Date(),
            payload: fakePayload(for: type)
        )
    }

}

extension ForkPayload: Fakeable {

    static func fake() -> ForkPayload {
        return ForkPayload(forkee: .fake())
    }

}

extension PushPayload: Fakeable {

    static func fake() -> PushPayload {
        return PushPayload(ref: "4321")
    }

}

extension IssuesPayload: Fakeable {

    static func fake() -> IssuesPayload {
        return IssuesPayload(action: "created", issue: .fake())
    }

}

extension IssueCommentPayload: Fakeable {

    static func fake() -> IssueCommentPayload {
        return IssueCommentPayload(action: "created", issue: .fake(), comment: .fake())
    }

}

extension Issue: Fakeable {

    static func fake() -> Issue {
        return Issue(id: ID(rawValue: UUID().hashValue), number: 999, title: "Let it swift!")
    }

}

extension Comment: Fakeable {

    static func fake() -> Comment {
        return Comment(id: ID(rawValue: UUID().hashValue), body: "Hello world!")
    }

}
