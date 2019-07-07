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
        }

        let activities: [Activity]
        let filters: ActivityListFilters

        static var initial = State(activities: [], filters: .init())

        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .load(let activities):
                return .init(activities: activities, filters: state.filters)
            case .filter(let filters):
                return .init(activities: [], filters: filters)
            }
        }

    }

    // MARK: - Inputs

    let searchByUser = PublishSubject<String>()

    let pushOnly = PublishSubject<Bool>()

    // MARK: - Outputs

    lazy var output = state(from:
        pollingLastActivities.map(Event.load(activities:)),
        filterLastActivities.map(Event.filter)
    )

    lazy var activityList = output[\.activities]
        .map { $0.compactMap(ActivityListItem.init(from:)) }
        .map { $0.sorted { $0.date < $1.date } }

    // MARK: - Events

    private lazy var pollingLastActivities = filterLastActivities.startWith(.init())
        .flatMapLatest { [unowned self] filters in
            self.activityPool.bufferedStream(interval: self.pollingInterval, size: self.listSize, filters: filters)
                .catchErrorJustReturn([])
        }

    private lazy var filterLastActivities = Observable.combineLatest(searchByUser, pushOnly)
        .map { userName, pushOnly in
            ActivityListFilters(
                userName: userName,
                predicate: { activity in
                    pushOnly ? activity.type == .push : true
                }
            )
        }

    // MARK: - Dependencies

    private let activityPool: ActivityPool

    private let listSize: Int

    private let pollingInterval: RxTimeInterval

    init(activityPool: ActivityPool = .init(), listSize: Int = 20, pollingInterval: RxTimeInterval = .seconds(60)) {
        self.activityPool = activityPool
        self.listSize = listSize
        self.pollingInterval = pollingInterval
    }

}
