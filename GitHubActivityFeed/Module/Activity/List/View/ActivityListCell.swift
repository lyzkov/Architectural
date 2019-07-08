//
//  ActivityListCell.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 08/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityListCell: UITableViewCell {

    @IBOutlet weak var actorAvatar: UIImageView!

    @IBOutlet weak var activityDate: UILabel!

    @IBOutlet weak var activityTitle: UILabel!

    func render(item: ActivityListItem) {
        activityTitle.text = item.title
        activityDate.text = item.date.shortFormatted
        actorAvatar.kf.indicatorType = .activity
        actorAvatar.kf.setImage(with: item.avatarUrl)
    }

}
