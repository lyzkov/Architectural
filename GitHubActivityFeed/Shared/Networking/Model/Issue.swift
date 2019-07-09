//
//  Issue.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct Issue: Identifiable, Decodable {
    typealias RawRepresentation = Int

    let id: ID
    let number: Int?
    let title: String
}
