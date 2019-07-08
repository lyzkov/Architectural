//
//  ActivityDetails.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

struct ActivityDetails: Renderable {
    let title: String
    let body: String?
    let avatarUrl: URL
    let date: Date
}

extension ActivityDetails {

    init?(from activity: Activity) {
        guard activity.type != nil else {
            return nil
        }

        title = activity.description.title
        body = activity.description.body
        avatarUrl = activity.actor.avatarUrl
        date = activity.createdAt
    }

}
