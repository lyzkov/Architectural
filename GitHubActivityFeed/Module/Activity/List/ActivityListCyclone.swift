//
//  ActivityListCyclone.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 03/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import RxCyclone

final class ActivityListCyclone: Cyclone {

    // MARK: - State reduction

    struct State: ReducibleState {

        enum Event: EventType {
            case load(activities: [Activity])
            case filter(ActivityListFilters)
            case select(id: Activity.ID)
        }

        let activities: [Activity]
        let filters: ActivityListFilters
        let selected: Activity?

        static var initial = State(activities: [], filters: .init(), selected: nil)

        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .load(let activities):
                return .init(activities: activities, filters: state.filters, selected: nil)
            case .filter(let filters):
                return .init(activities: [], filters: filters, selected: nil)
            case .select(let id):
                let selected = state.activities.first { $0.id == id }
                return .init(activities: state.activities, filters: state.filters, selected: selected)
            }
        }

    }

    // MARK: - Inputs

    let searchByUser = PublishSubject<String>()

    let pushOnly = PublishSubject<Bool>()

    let select = PublishSubject<Activity.ID>()

    // MARK: - Outputs

    lazy var output = state(from:
        pollingSource.map(Event.load(activities:)),
        filteringSource.map(Event.filter),
        selectionSource.map(Event.select(id:))
    )

    lazy var listed = output[\.activities]
        .map { $0.compactMap(ActivityListItem.init(from:)) }
        .share(replay: 1)

    lazy var selected = output[\.selected]
        .compactMap { $0 }
        .distinctUntilChanged()
        .share(replay: 1)

    // MARK: - Sources

    private lazy var pollingSource = filteringSource
        .startWith(.init())
        .flatMapLatest { [unowned self] filters in
            self.pool.bufferedStream(interval: self.pollingInterval, size: self.listSize, filters: filters)
                .debug()
                .catchErrorJustReturn([])
        }

    private lazy var filteringSource = Observable.combineLatest(searchByUser, pushOnly)
        .map { userName, pushOnly in
            ActivityListFilters(
                userName: userName,
                predicate: { activity in
                    pushOnly ? activity.type == .push : true
                }
            )
        }

    private lazy var selectionSource = select

    // MARK: - Dependencies

    private let pool: ActivityPool

    private let listSize: Int

    private let pollingInterval: RxTimeInterval

    init(pool: ActivityPool = .init(), listSize: Int = 20, pollingInterval: RxTimeInterval = .seconds(60)) {
        self.pool = pool
        self.listSize = listSize
        self.pollingInterval = pollingInterval
    }

}
