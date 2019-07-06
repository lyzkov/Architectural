//
//  Event.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 27/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

enum ActivityType: String, CaseIterable, Decodable {
    case push = "PushEvent"
    case fork = "ForkEvent"
    case issues = "IssuesEvent"
    case issueComment = "IssueCommentEvent"
}

struct Activity: Identifiable {
    let id: ID
    let type: ActivityType?
    let actor: User
    let repo: Repository
    let createdAt: Date
    let payload: Payload?
}

extension Activity: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case actor
        case repo
        case payload
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(ID.self, forKey: .id)
        type = try? container.decode(ActivityType.self, forKey: .type)
        actor = try container.decode(User.self, forKey: .actor)
        repo = try container.decode(Repository.self, forKey: .repo)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        payload = try Activity.decodePayload(of: type, container: container)
    }

    private static func decodePayload(of type: ActivityType?, container: KeyedDecodingContainer<Activity.CodingKeys>)
        throws -> Payload? {
        switch type {
        case .push?:
            return try container.decode(PushPayload.self, forKey: .payload)
        case .fork?:
            return try container.decode(ForkPayload.self, forKey: .payload)
        case .issues?:
            return try container.decode(IssuesPayload.self, forKey: .payload)
        case .issueComment?:
            return try container.decode(IssueCommentPayload.self, forKey: .payload)
        case .none:
            return nil
        }
    }

}

extension Activity: Hashable {

    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
