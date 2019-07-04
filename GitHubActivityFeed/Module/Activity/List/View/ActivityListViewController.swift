//
//  ActivityListViewController.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 26/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxCyclone

final class ActivityListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cyclone = ActivityListCyclone()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        // Configure cells

        cyclone.output[\.activityList]
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: R.reuseIdentifier.activityCell.identifier,
                cellType: UITableViewCell.self
            )) { _, activity, cell in
                cell.textLabel?.text = activity.description
            }
            .disposed(by: disposeBag)
    }

}
