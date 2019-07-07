//
//  ActivityListItem.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 04/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct ActivityListItem: Identifiable {
    let id: ID
    let description: String
    let date: Date
    let avatar: URL?
}

extension ActivityListItem {

    init?(from activity: Activity) {
        guard let type = activity.type else {
            return nil
        }
        id = .init(rawValue: activity.id.rawValue)
        description = type.rawValue
        date = activity.createdAt
        avatar = nil
    }

}

extension ActivityListItem: Renderable {
}
