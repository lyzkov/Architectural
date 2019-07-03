//
//  ActivityCellModel.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 26/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

struct ActivityCellModel {
    let description: String
    let date: Date
    let avatar: URL?
}

extension ActivityCellModel {

    init?(from activity: Activity) {
        guard let type = activity.type else {
            return nil
        }

        description = type.rawValue
        date = activity.createdAt
        avatar = nil
    }

}
