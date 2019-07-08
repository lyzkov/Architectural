//
//  ActivityListItem.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 04/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Identity

struct ActivityListItem: Renderable {
    let id: Activity.ID
    let title: String
    let date: Date
    let avatarUrl: URL?
}

extension ActivityListItem {

    init?(from activity: Activity) {
        guard activity.type != nil else {
            return nil
        }
        
        id = activity.id
        title = activity.description.title
        date = activity.createdAt
        avatarUrl = activity.actor.avatarUrl
    }

}
