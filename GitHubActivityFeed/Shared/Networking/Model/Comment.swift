//
//  Comment.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct Comment: Identifiable, Decodable {
    typealias RawRepresentation = Int

    let id: ID
    let body: String?
}
