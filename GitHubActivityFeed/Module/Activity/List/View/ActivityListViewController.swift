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
import RxNavy
import Kingfisher

final class ActivityListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var pushOnlySwitch: UISwitch!

    @IBOutlet weak var userNameSearch: UISearchBar!

    // MARK: - Dependencies

    lazy var cyclone = ActivityListCyclone(errorShooter: AlertErrorShooter(presenter: self))

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // List

        cyclone.listed.render(with: self).disposed(by: disposeBag)

        // Selecting

        tableView.rx.modelSelected(ActivityListItem.self)
            .do(onNext: { [unowned self] _ in
                self.tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            })
            .map { $0.id }
            .bind(to: cyclone.select)
            .disposed(by: disposeBag)

        // Prefetching

        tableView.rx.prefetchRows
            .withLatestFrom(cyclone.listed) { indexPathes, activityList in
                indexPathes.compactMap { activityList[$0.item].avatarUrl }
            }
            .subscribe(onNext: { urls in
                ImagePrefetcher(urls: urls).start()
            })
            .disposed(by: disposeBag)

        tableView.rx.cancelPrefetchingForRows
            .withLatestFrom(cyclone.listed) { indexPathes, activityList in
                indexPathes.compactMap { activityList[$0.item].avatarUrl }
            }
            .subscribe(onNext: { urls in
                ImagePrefetcher(urls: urls).stop()
            })
            .disposed(by: disposeBag)

        // Filters

        userNameSearch.rx.text.orEmpty
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: cyclone.searchByUser)
            .disposed(by: disposeBag)
        
        pushOnlySwitch.rx.isOn.bind(to: cyclone.pushOnly).disposed(by: disposeBag)

        // Segues

        let selectItemSegue = rx.segue(identifier: R.segue.activityListViewController.showDetails.identifier)
            .map { (destination: ActivityDetailsViewController, _: UITableViewCell) in
                destination
            }
        cyclone.selected
            .withLatestFrom(selectItemSegue) { ($0, $1) }
            .subscribe(onNext: { activity, destination in
                destination.cyclone.activity.onNext(activity)
            })
            .disposed(by: disposeBag)

        // Errors


    }

}

// TODO: render data in cell

extension ActivityListViewController: ListRendering, TableViewConfiguring {

    func configureCell(dataSource: TableViewSectionedDataSource<AnimatableSectionModel<String, ActivityListItem>>, tableView: UITableView, indexPath: IndexPath, item: ActivityListItem) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.activityListCell.identifier,
            for: indexPath
        ) as! ActivityListCell
        cell.render(item: item)

        return cell
    }

}

extension ActivityListItem: Equatable {

    static func ==(lhs: ActivityListItem, rhs: ActivityListItem) -> Bool {
        return lhs.id == rhs.id
    }

}

extension ActivityListItem: RxDataSources.IdentifiableType {

    var identity: Activity.ID {
        return id
    }
    
}
