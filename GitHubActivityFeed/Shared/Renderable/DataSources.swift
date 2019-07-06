//
//  DataSources.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 06/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxDataSources
import RxSwift

protocol TableViewConfiguring {
    associatedtype ConfiguredItem: Renderable & IdentifiableType & Equatable

    var tableView: UITableView! { get }
    func configureCell(dataSource: TableViewSectionedDataSource<AnimatableSectionModel<String, ConfiguredItem>>,
                       tableView: UITableView, indexPath: IndexPath, item: ConfiguredItem) -> UITableViewCell
}

extension ListRendering where Self: TableViewConfiguring, ConfiguredItem == Item {
    private typealias SectionModel = AnimatableSectionModel<String, Item>
    private typealias DataSource = RxTableViewSectionedAnimatedDataSource<SectionModel>

    var items: (Observable<[Item]>) -> Disposable {
        return { [weak self] source in
            guard let self = self else {
                return Disposables.create()
            }

            let source = source
                .map { SectionModel(model: "", items: Array($0)) }
                .map { [$0] }

            return self.tableView.rx.items(dataSource: DataSource(configureCell: self.configureCell))(source)
        }
    }

}