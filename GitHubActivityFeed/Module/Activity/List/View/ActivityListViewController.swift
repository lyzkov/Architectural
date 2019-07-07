//
//  ActivityListViewController.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 26/06/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class ActivityListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var pushOnlySwitch: UISwitch!

    @IBOutlet weak var userNameSearch: UISearchBar!

    // MARK: - Dependencies

    private let cyclone = ActivityListCyclone()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        cyclone.activityList.render(with: self).disposed(by: disposeBag)

        userNameSearch.rx.text.orEmpty
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: cyclone.searchByUser)
            .disposed(by: disposeBag)
        
        pushOnlySwitch.rx.isOn.bind(to: cyclone.pushOnly).disposed(by: disposeBag)
    }

}

// TODO: render data in cell

extension ActivityListViewController: ListRendering, TableViewConfiguring {

    func configureCell(dataSource: TableViewSectionedDataSource<AnimatableSectionModel<String, ActivityListItem>>, tableView: UITableView, indexPath: IndexPath, item: ActivityListItem) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.activityCell.identifier,
            for: indexPath
        )
        cell.textLabel?.text = item.description

        return cell
    }

}

extension ActivityListItem: Equatable {

    static func ==(lhs: ActivityListItem, rhs: ActivityListItem) -> Bool {
        return lhs.id == rhs.id
    }

}

extension ActivityListItem: RxDataSources.IdentifiableType {

    var identity: ID {
        return id
    }
    
}
