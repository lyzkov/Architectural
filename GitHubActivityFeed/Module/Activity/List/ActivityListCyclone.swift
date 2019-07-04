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
        }

        private let activities: [Activity]

        static var initial = State(activities: [])

        static func reduce(state: State, event: Event) -> State {
            switch event {
            case .load(let activities):
                return .init(activities: activities)
            }
        }

        var activityList: [ActivityCellModel] {
            return activities.compactMap(ActivityCellModel.init(from:))
        }

    }

    // MARK: - Events

    private lazy var loadLastActivities = activityPool.list(page: 1, perPage: maxLenght).map(Event.load(activities:))

    // MARK: - Outputs

    lazy var output = state(from: loadLastActivities)

    // MARK: - Dependencies

    private let activityPool: ActivityPool

    private let maxLenght: Int

    init(activityPool: ActivityPool = ActivityPool(), maxLenght: Int = 20) {
        self.activityPool = activityPool
        self.maxLenght = maxLenght
    }

}
