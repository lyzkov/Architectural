//
//  ActivityDetails.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import Foundation

struct ActivityDetails: Renderable {
    let description: String
}

extension ActivityDetails {

    init?(from activity: Activity) {
        guard let type = activity.type else {
            return nil
        }

        description = type.rawValue
    }

}
