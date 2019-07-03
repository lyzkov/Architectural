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

final class ActivityListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let dataPool = ActivityPool()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        // Configure cells

        fetchData()
            .drive(tableView.rx.items(
                cellIdentifier: R.reuseIdentifier.activityCell.identifier,
                cellType: UITableViewCell.self
            )) { _, activity, cell in
                cell.textLabel?.text = activity.description
            }
            .disposed(by: disposeBag)
    }

    private func fetchData() -> Driver<[ActivityCellModel]> {
        return dataPool.list(page: 1, perPage: 20)
            .map { activities in
                activities.compactMap(ActivityCellModel.init(from:))
            }
            .asDriver(onErrorJustReturn: [])
    }

}
