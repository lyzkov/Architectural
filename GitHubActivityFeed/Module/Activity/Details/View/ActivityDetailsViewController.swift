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

    @IBOutlet private weak var actionDescription: UILabel!

    // MARK: - Dependencies

    let cyclone = ActivityDetailsCyclone()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        cyclone.activityDetails.render(with: self).disposed(by: disposeBag)
    }

}

extension ActivityDetailsViewController: Rendering {

    func render(item: ActivityDetails?) {
        actionDescription.text = item?.description
    }

}
