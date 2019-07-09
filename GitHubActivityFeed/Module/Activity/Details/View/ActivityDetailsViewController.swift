//
//  ActivityDetailsViewController.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 07/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import UIKit
import RxSwift

final class ActivityDetailsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var actorAvatar: UIImageView!

    @IBOutlet weak var activityTitle: UILabel!

    @IBOutlet weak var activityBody: UILabel!

    // MARK: - Dependencies

    // TODO: dependency injection

    let cyclone = ActivityDetailsCyclone()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        cyclone.detailed.render(with: self).disposed(by: disposeBag)
    }

}

extension ActivityDetailsViewController: Rendering {

    func render(item: ActivityDetails?) {
        actorAvatar.kf.indicatorType = .activity
        actorAvatar.kf.setImage(with: item?.avatarUrl)
        activityTitle.text = item?.title
        activityBody.text = item?.body
    }

}
