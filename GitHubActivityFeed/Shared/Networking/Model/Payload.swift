//
//  Payload.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 03/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

protocol Payload: Decodable {
}

struct PushPayload: Payload {
    let ref: String
}

struct ForkPayload: Payload {
    let forkee: Repository
}

struct IssuesPayload: Payload {
    let action: String?
    let issue: Issue?
}

struct IssueCommentPayload: Payload {
    let action: String?
    let issue: Issue?
    let comment: Comment?
}
