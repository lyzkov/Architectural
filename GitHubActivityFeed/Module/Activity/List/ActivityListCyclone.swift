//
//  ActivityListCyclone.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 03/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import RxSwift
import RxCyclone
import Action

final class ActivityListCyclone: Cyclone {

    // MARK: - State reduction

    struct State: ReducibleState {

        enum Event: EventType {
            case load(activities: [Activity])
        }

        let activities: [Activity]

        static var initial = State(activities: [])

        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .load(let activities):
                return .init(activities: activities)
            }
        }

    }

    // MARK: - Inputs

    lazy var refresh = Action<Void, [Activity]> { [activityPool, listSize] _ in
        activityPool.list(page: 1, perPage: listSize)
    }

    // MARK: - Outputs

    lazy var output = state(from: pollingLastActivities, refreshLastActivities)

    lazy var activityList = output[\.activities]
        .map { $0.compactMap(ActivityListItem.init(from:)) }

    // MARK: - Events

    private lazy var pollingLastActivities = activityPool.bufferedStream(interval: pollingInterval, size: listSize)
        .map(Event.load(activities:))

    private lazy var refreshLastActivities = refresh.elements
        .map(Event.load(activities:))

    // MARK: - Dependencies

    private let activityPool: ActivityPool

    private let listSize: Int

    private let pollingInterval: RxTimeInterval

    init(activityPool: ActivityPool = ActivityPool(),
         listSize: Int = 20,
         pollingInterval: RxTimeInterval = .seconds(60)) {
        self.activityPool = activityPool
        self.listSize = listSize
        self.pollingInterval = pollingInterval
    }

}
