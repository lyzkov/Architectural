//
//  Repository.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 03/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct Repository: Decodable, Identifiable {
    typealias RawRepresentation = Int

    let id: ID
    let name: String
}
